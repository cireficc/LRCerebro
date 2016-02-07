class AddGoogleCalendarAttributesToProjectReservation < ActiveRecord::Migration
    def change
        add_column :project_reservations, :google_calendar_event_id, :string
        add_column :project_reservations, :google_calendar_html_link, :string
    end
end
