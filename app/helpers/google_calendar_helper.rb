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
    
    HOURS_PER_DAY = 24
    MINUTES_PER_DAY = 60 * 24
    SECONDS_PER_DAY = 60 * 60 * 24
    TIME_ZONE = "America/Detroit"
    RESERVATION_CALENDAR_ID = ENV["google_calendar_reservation_cal_id"]
   
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
        @instructor = @course.get_instructor
        @last_name = @instructor.last_name
        @num_students = @course.get_students.count
        @index = @res.training? ? @training.index(@res) : @editing.index(@res)
        @total = @res.training? ? @training.length : @editing.length
        
        # e.g.
        # (not approved) "HOLD: FRE 101-01, Ward, 24 (Camtasia Training 1 of 2)"
        # (approved) "FRE 101-01, Ward, 24 (Camtasia Editing 1 of 3)"
        @event_title =
            "#{'HOLD: ' if !@project.approved?}"\
            "#{@course.get_short_name}, #{@instructor.last_name}, #{@num_students}"\
            " (#{@project.category.camelize} #{res.category.camelize} #{@index + 1} of #{@total})"
        
        # Change the time zone of the reservation start/end from UTC without affecting the time value
        @start_time = ActiveSupport::TimeZone.new(TIME_ZONE).local_to_utc(@res.start)
        @end_time = ActiveSupport::TimeZone.new(TIME_ZONE).local_to_utc(@res.end)
        
        @g_cal_event = Google::Apis::CalendarV3::Event.new({
            summary: @event_title,
            location: @res.lab.camelize,
            description: @project.description,
            start: {
                date_time: @start_time.to_datetime,
                time_zone: TIME_ZONE
            },
            end: {
                date_time: @end_time.to_datetime,
                time_zone: TIME_ZONE
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
        @calendar.delete_event(RESERVATION_CALENDAR_ID, project_reservation.google_calendar_event_id)
    end
end