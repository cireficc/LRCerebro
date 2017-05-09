require 'googleauth'
require 'google/apis/calendar_v3'

# A helper class for the Google Calendar V3 API
# This class will take care of instantiating a new calendar and authorizing to reduce
# duplication of such code. It will also hold the Google API scopes required by the
# application.
# This class is also used to simplify ProjectReservation scheduling by having helper
# methods to take a Project object and schedule its events on the calendar via a
# batch request: https://developers.google.com/api-client-library/ruby/guide/batch.
module GoogleCalendarHelper
    
    include ApplicationHelper
    
    HOURS_PER_DAY = 24
    MINUTES_PER_DAY = 60 * 24
    SECONDS_PER_DAY = 60 * 60 * 24
    RESERVATION_CALENDAR_ID = Rails.application.secrets.google_calendar_reservation_cal
    PROJECT_PUBLISHING_CALENDAR_ID = Rails.application.secrets.google_calendar_project_publishing_cal
   
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.authorization = Google::Auth.get_application_default(GoogleApiHelper::SCOPES)
   
    def get_calendar
        @calendar
    end
    
    # Schedule project event in Google Calendar based on the ActiveRecord callback on a ProjectReservation:
    # :create - create project event
    # :update - update project event
    def self.schedule_project_event(res, action)
        
        @res = res
        @project = @res.project
        @training = @project.project_reservations.where(category: ProjectReservation.categories[:training]).order(:start)
        @editing = @project.project_reservations.where(category: ProjectReservation.categories[:editing]).order(:start)
        
        @course = @project.course
        @instructor = @course.instructor
        @last_name = @instructor.last_name
        @num_students = @course.students.count
        @lab = @res.lab.titleize if @res.lab
        @index = @res.training? ? @training.index(@res) : @editing.index(@res)
        @total = @res.training? ? @training.length : @editing.length
        
        # e.g.
        # (not approved) "HOLD: FRE 101-01, Ward, 24 (Camtasia Training 1 of 2) - ProjIntro"
        # (approved) "FRE 101-01, Ward, 24 (Camtasia Editing 1 of 3) - In-cl Shoot"
        @event_title =
            "#{'HOLD: ' if !@project.approved?}"\
            "#{@course.decorate.short_name}, #{@instructor.last_name}, #{@num_students}"\
            " (#{@project.category.titleize} #{@res.category.titleize} #{@index + 1} of #{@total})"

        if (@res.subtype)
            @event_title = @event_title + " - #{ProjectReservationDecorator::SUBTYPES_SHORTHAND[@res.subtype.to_sym]}"
        end
        
        # Change the time zone of the reservation start/end from UTC without affecting the time value
        @start_time = ApplicationHelper.local_to_utc(@res.start)
        @end_time = ApplicationHelper.local_to_utc(@res.end)
        
        @g_cal_event = Google::Apis::CalendarV3::Event.new({
            summary: @event_title,
            location: @lab,
            description: @project.description,
            start: {
                date_time: @start_time.to_datetime,
                time_zone: LOCAL_TIME_ZONE
            },
            end: {
                date_time: @end_time.to_datetime,
                time_zone: LOCAL_TIME_ZONE
            },
            attendees: [
                {email: "shultzd@gvsu.edu"},
                {email: "clappve@gvsu.edu"},
                {email: "#{@instructor.username}@gvsu.edu"}
            ]
        })
        
        if action == :create
            @event = @calendar.insert_event(RESERVATION_CALENDAR_ID, @g_cal_event)
            @res.update_columns(google_calendar_event_id: @event.id, google_calendar_html_link: @event.html_link)
        elsif action == :update
            @calendar.patch_event(RESERVATION_CALENDAR_ID, @res.google_calendar_event_id, @g_cal_event)
        end
    end
    
    def self.delete_project_event(project_reservation)
        begin
            @calendar.delete_event(RESERVATION_CALENDAR_ID, project_reservation.google_calendar_event_id)
        rescue Google::Apis::ClientError
            puts "Event no longer exists, ignore trying to delete it"
        end
    end

    # Schedule project publish event in Google Calendar based on the ActiveRecord callback on a Project:
    # :create - create project publish event
    # :update - update project publish event
    def self.schedule_project_publish_event(project, action)

        @project = project
        @course = @project.course
        @instructor = @course.instructor
        @start_time = @project.viewable_by - 2.hours
        @end_time = @project.viewable_by

        # e.g. "Publishing: (Camtasia) Ward FRE 101-01"
        @event_title = "Publishing: (#{@project.category.titleize}) #{@instructor.last_name} #{@course.decorate.short_name}"

        # Change the time zone of the reservation start/end from UTC without affecting the time value
        @start_time = ApplicationHelper.local_to_utc(@start_time)
        @end_time = ApplicationHelper.local_to_utc(@end_time)
        
        @g_cal_event = Google::Apis::CalendarV3::Event.new({
           summary: @event_title,
           start: {
               date_time: @start_time.to_datetime,
               time_zone: LOCAL_TIME_ZONE
           },
           end: {
               date_time: @end_time.to_datetime,
               time_zone: LOCAL_TIME_ZONE
           }
        })

        if action == :create
            @event = @calendar.insert_event(PROJECT_PUBLISHING_CALENDAR_ID, @g_cal_event)
            @project.update_columns(google_calendar_publish_event_id: @event.id)
        elsif action == :update
            @calendar.patch_event(PROJECT_PUBLISHING_CALENDAR_ID, @project.google_calendar_publish_event_id, @g_cal_event)
        end
    end

    def self.delete_project_publish_event(project)
        begin
            @calendar.delete_event(PROJECT_PUBLISHING_CALENDAR_ID, project.google_calendar_publish_event_id)
        rescue Google::Apis::ClientError
            puts "Event no longer exists, ignore trying to delete it"
        end
    end
    
    # Schedule standard reservation in Google Calendar based on the ActiveRecord callback on a StandardReservation:
    # :create - create standard reservation
    # :update - update standard reservation
    def self.schedule_standard_reservation(res, action)
        
        #[:course_id, :activity, :start, :end, :lab, :walkthrough, :additional_instructions, utilities: [], assistances: []]
        
        @res = res
        
        @course = @res.course
        @instructor = @course.instructor
        @last_name = @instructor.last_name
        @num_students = @course.students.count
        @lab = @res.lab.titleize
        
        # e.g.
        # "FRE 101-01, Ward, 24 (Dill Paired Recordings [Walkthrough: YES])"
        @event_title =
            "#{@course.decorate.short_name}, #{@instructor.last_name}, #{@num_students}"\
            " (#{@res.activity.titleize} [Walkthrough: #{@res.walkthrough? ? 'YES' : 'NO'}])"
        
        # Change the time zone of the reservation start/end from UTC without affecting the time value
        @start_time = ApplicationHelper.local_to_utc(@res.start)
        @end_time = ApplicationHelper.local_to_utc(@res.end)
        
        @g_cal_event = Google::Apis::CalendarV3::Event.new({
            summary: @event_title,
            location: @lab,
            description: @res.additional_instructions,
            start: {
                date_time: @start_time.to_datetime,
                time_zone: LOCAL_TIME_ZONE
            },
            end: {
                date_time: @end_time.to_datetime,
                time_zone: LOCAL_TIME_ZONE
            },
            attendees: [
                {email: "shultzd@gvsu.edu"},
                {email: "clappve@gvsu.edu"},
                {email: "#{@instructor.username}@gvsu.edu"}
            ]
        })
        
        if action == :create
            @event = @calendar.insert_event(RESERVATION_CALENDAR_ID, @g_cal_event)
            @res.update_columns(google_calendar_event_id: @event.id, google_calendar_html_link: @event.html_link)
        elsif action == :update
            @calendar.patch_event(RESERVATION_CALENDAR_ID, @res.google_calendar_event_id, @g_cal_event)
        end
    end
    
    def self.delete_standard_reservation(standard_reservation)
        begin
            @calendar.delete_event(RESERVATION_CALENDAR_ID, standard_reservation.google_calendar_event_id)
        rescue Google::Apis::ClientError
            puts "Event no longer exists, ignore trying to delete it"
        end
    end
end