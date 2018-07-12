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
  RESERVATION_CALENDAR_ID = Figaro.env.google_calendar_reservation_cal_id
  PROJECT_PUBLISHING_CALENDAR_ID = Figaro.env.google_calendar_project_publishing_cal_id
  VIDCAM_CALENDAR_ID = Figaro.env.google_calendar_vidcam_cal_id

  @calendar = Google::Apis::CalendarV3::CalendarService.new
  @calendar.authorization = Google::Auth.get_application_default(GoogleApiHelper::SCOPES)

  def self.get_calendar
    @calendar
  end
  
  def self.project_reservation_calendar_event(project_reservation)
    
    project = project_reservation.project
    training = project.project_reservations.where(category: :training).order(:start)
    editing = project.project_reservations.where(category: :editing).order(:start)

    course = project.course
    instructor = course.instructor
    num_students = course.students.count
    lab = project_reservation.lab.titleize if project_reservation.lab
    index = project_reservation.training? ? training.index(project_reservation) : editing.index(project_reservation)
    total = project_reservation.training? ? training.length : editing.length

    # e.g.
    # (not approved) "HOLD: FRE 101-01, Ward, 24 (Camtasia Training 1 of 2) - ProjIntro"
    # (approved) "FRE 101-01, Ward, 24 (Camtasia Editing 1 of 3) - In-cl Shoot"
    event_title =
        "#{'HOLD: ' unless project.approved?}"\
          "#{course.decorate.short_name}, #{instructor.last_name}, #{num_students}"\
          " (#{project.category} #{project_reservation.category.titleize} #{index + 1} of #{total})"

    event_description =
        "Staff notes: #{project_reservation.staff_notes}\n\n"\
		    "Faculty notes: #{project_reservation.faculty_notes}\n"\
		    "-------------------------\n"\
		    "Project description: #{project.description}"

    if project_reservation.subtype
      event_title += " - #{ProjectReservationDecorator::SUBTYPES_SHORTHAND[project_reservation.subtype.to_sym]}"
    end

    # Change the time zone of the reservation start/end from UTC without affecting the time value
    start_time = ApplicationHelper.local_to_utc(project_reservation.start)
    end_time = ApplicationHelper.local_to_utc(project_reservation.end)

    Google::Apis::CalendarV3::Event.new(summary: event_title,
                                        location: lab,
                                        description: event_description,
                                        start: {
                                            date_time: start_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        end: {
                                            date_time: end_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        attendees: [
                                            {email: 'shultzd@gvsu.edu'},
                                            {email: 'clappve@gvsu.edu'},
                                            {email: "#{instructor.username}@gvsu.edu"}
                                        ])
  end

  def self.create_project_reservation_event(id)

    reservation = ProjectReservation.find(id)

    cal_event_data = project_reservation_calendar_event(reservation)
    event = @calendar.insert_event(RESERVATION_CALENDAR_ID, cal_event_data)
    reservation.update_columns(google_calendar_event_id: event.id, google_calendar_html_link: event.html_link)
  end
  
  def self.update_project_reservation_event(id)

    reservation = ProjectReservation.find(id)

    cal_event_data = project_reservation_calendar_event(reservation)
    @calendar.patch_event(RESERVATION_CALENDAR_ID, reservation.google_calendar_event_id, cal_event_data)
  end

  def self.delete_project_reservation_event(google_calendar_event_id)
    
    @calendar.delete_event(RESERVATION_CALENDAR_ID, google_calendar_event_id)
  end
  
  def self.project_publish_calendar_event(project)
    project = project.decorate
    course = project.course
    instructor = course.instructor
    start_time = project.publish_by - 2.hours
    end_time = project.publish_by

    # project can be an instance of Project or MiniProject; the event title and description change based on the class
    if project.instance_of? Project
      # e.g. "Project Publishing: (Camtasia) Ward FRE 101-01"
      event_title = "Project Publishing: (#{project.category}) #{instructor.last_name} #{course.decorate.short_name}"
      event_description = 'Publish according to project type.'
    else
      # e.g. "MiniProject Publishing: (Camtasia) Ward FRE 101-01"
      event_title = "Mini Project Publishing: (#{project.stringified_resources}) #{instructor.last_name} #{course.decorate.short_name}"
      event_description =
          "Publish: #{project.stringified_publish_methods}\n"\
              "Resources: #{project.stringified_resources}\n\n"\
              "#{project.description}"
    end

    # Change the time zone of the reservation start/end from UTC without affecting the time value
    start_time = ApplicationHelper.local_to_utc(start_time)
    end_time = ApplicationHelper.local_to_utc(end_time)

    Google::Apis::CalendarV3::Event.new(summary: event_title,
                                        description: event_description,
                                        start: {
                                            date_time: start_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        end: {
                                            date_time: end_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        })
  end
  
  def self.create_project_publish_event(id)
    
    project = Project.find(id)
    
    cal_event_data = project_publish_calendar_event(project)
    event = @calendar.insert_event(PROJECT_PUBLISHING_CALENDAR_ID, cal_event_data)
    project.update_columns(google_calendar_publish_event_id: event.id)
  end

  def self.update_project_publish_event(id)

    project = Project.find(id)

    cal_event_data = project_publish_calendar_event(project)
    @calendar.patch_event(PROJECT_PUBLISHING_CALENDAR_ID, project.google_calendar_publish_event_id, cal_event_data)
  end

  def self.delete_project_publish_event(google_calendar_publish_event_id)
    
    @calendar.delete_event(PROJECT_PUBLISHING_CALENDAR_ID, google_calendar_publish_event_id)
  end

  def self.create_mini_project_publish_event(id)

  end
  
  def self.update_mini_project_publish_event(id)
    
  end
  
  def self.delete_mini_project_publish_event(id)
    
  end

  def self.standard_reservation_calendar_event(reservation)

    course = reservation.course
    instructor = course.instructor
    num_students = course.students.count
    lab = reservation.lab.titleize

    # e.g.
    # "FRE 101-01, Ward, 24 (Dill Paired Recordings [Walkthrough: YES])"
    event_title =
        "#{course.decorate.short_name}, #{instructor.last_name}, #{num_students}"\
          " (#{reservation.activity} [Walkthrough: #{reservation.walkthrough? ? 'YES' : 'NO'}])"

    # Change the time zone of the reservation start/end from UTC without affecting the time value
    start_time = ApplicationHelper.local_to_utc(reservation.start)
    end_time = ApplicationHelper.local_to_utc(reservation.end)

    Google::Apis::CalendarV3::Event.new(summary: event_title,
                                        location: lab,
                                        description: reservation.additional_instructions,
                                        start: {
                                            date_time: start_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        end: {
                                            date_time: end_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        attendees: [
                                            {email: 'shultzd@gvsu.edu'},
                                            {email: 'clappve@gvsu.edu'},
                                            {email: "#{instructor.username}@gvsu.edu"}
                                        ])
  end
  
  def self.create_standard_reservation(id)
    
    reservation = StandardReservation.find(id)
		
		cal_event_data = standard_reservation_calendar_event(reservation)
    event = @calendar.insert_event(RESERVATION_CALENDAR_ID, cal_event_data)
    reservation.update_columns(google_calendar_event_id: event.id, google_calendar_html_link: event.html_link)
  end
  
  def self.update_standard_reservation(id)

    reservation = StandardReservation.find(id)
    
    cal_event_data = standard_reservation_calendar_event(reservation)
    @calendar.patch_event(RESERVATION_CALENDAR_ID, reservation.google_calendar_event_id, cal_event_data)
  end

  def self.delete_standard_reservation(google_calendar_event_id)

    @calendar.delete_event(RESERVATION_CALENDAR_ID, google_calendar_event_id)
  end
  
  def self.vidcam_filming_calendar_event(vidcam)
    
    course = vidcam.course
    instructor = course.instructor

    # e.g. "Filming: FRE 101-01, Ward, MAK D-2-221"
    event_title = "Filming: #{course.decorate.short_name}, #{instructor.last_name}, #{vidcam.location}"

    # Change the time zone of the reservation start/end from UTC without affecting the time value
    start_time = ApplicationHelper.local_to_utc(vidcam.start)
    end_time = ApplicationHelper.local_to_utc(vidcam.end)

    Google::Apis::CalendarV3::Event.new(summary: event_title,
                                        location: vidcam.location,
                                        description: vidcam.additional_instructions,
                                        start: {
                                            date_time: start_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        end: {
                                            date_time: end_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        attendees: [
                                            {email: 'shultzd@gvsu.edu'},
                                            {email: 'clappve@gvsu.edu'},
                                            {email: "#{instructor.username}@gvsu.edu"}
                                        ])
  end

  
  def self.create_vidcam_filming_event(id)
    
    vidcam = Vidcam.find(id)
    cal_event_data = vidcam_filming_calendar_event(vidcam)

    event = @calendar.insert_event(VIDCAM_CALENDAR_ID, cal_event_data)
    vidcam.update_columns(google_calendar_filming_event_id: event.id)
  end

  def self.update_vidcam_filming_event(id)

    vidcam = Vidcam.find(id)
    cal_event_data = vidcam_filming_calendar_event(vidcam)

    @calendar.patch_event(VIDCAM_CALENDAR_ID, vidcam.google_calendar_filming_event_id, cal_event_data)
  end

  def self.delete_vidcam_filming_event(google_calendar_filming_event_id)

    @calendar.delete_event(VIDCAM_CALENDAR_ID, google_calendar_filming_event_id)
  end

  def self.vidcam_publishing_calendar_event(vidcam)

    vidcam = vidcam.decorate
    course = vidcam.course
    instructor = course.instructor
    start_time = vidcam.publish_by - 2.hours
    end_time = vidcam.publish_by

    # e.g. "Publishing: FRE 101-01, Ward, MAK D-2-221"
    event_title = "Publishing: #{course.decorate.short_name}, #{instructor.last_name}, #{vidcam.location}"
    event_description =
        "Publish: #{vidcam.stringified_publish_methods}\n"\
          "Upload to Ensemble? #{vidcam.upload_to_ensemble_string}\n\n"\
          "#{vidcam.additional_instructions}"

    # Change the time zone of the reservation start/end from UTC without affecting the time value
    start_time = ApplicationHelper.local_to_utc(start_time)
    end_time = ApplicationHelper.local_to_utc(end_time)

    Google::Apis::CalendarV3::Event.new(summary: event_title,
                                        location: vidcam.location,
                                        description: event_description,
                                        start: {
                                            date_time: start_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        end: {
                                            date_time: end_time.to_datetime,
                                            time_zone: LOCAL_TIME_ZONE
                                        },
                                        attendees: [
                                            {email: 'shultzd@gvsu.edu'},
                                            {email: 'clappve@gvsu.edu'},
                                            {email: "#{instructor.username}@gvsu.edu"}
                                        ])
  end


  def self.create_vidcam_publishing_event(id)

    vidcam = Vidcam.find(id)
    cal_event_data = vidcam_publishing_calendar_event(vidcam)

    event = @calendar.insert_event(VIDCAM_CALENDAR_ID, cal_event_data)
    vidcam.update_columns(google_calendar_publishing_event_id: event.id)
  end

  def self.update_vidcam_publishing_event(id)

    vidcam = Vidcam.find(id)
    cal_event_data = vidcam_publishing_calendar_event(vidcam)

    @calendar.patch_event(VIDCAM_CALENDAR_ID, vidcam.google_calendar_publishing_event_id, cal_event_data)
  end

  def self.delete_vidcam_publishing_event(google_calendar_publishing_event_id)

    @calendar.delete_event(VIDCAM_CALENDAR_ID, google_calendar_publishing_event_id)
  end
  
  def self.list_events_for_calendar(calendar_id)
    response = @calendar.list_events(calendar_id,
                                   max_results: 10,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: 1.month.ago.iso8601)
    puts "Upcoming events: #{response.items.count}"
    puts 'No upcoming events found' if response.items.empty?
    response.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} (#{start})"
    end
  end
end
