class AddGoogleCalendarAttributesToProjectReservation < ActiveRecord::Migration[4.2]

def change
        add_column :project_reservations, :google_calendar_event_id, :string
        add_column :project_reservations, :google_calendar_html_link, :string
    end
end
