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
    SCOPES =  ["https://www.googleapis.com/auth/calendar", "https://mail.google.com"]
   
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.authorization = Google::Auth.get_application_default(SCOPES)
   
    def get_calendar
        @calendar
    end
end