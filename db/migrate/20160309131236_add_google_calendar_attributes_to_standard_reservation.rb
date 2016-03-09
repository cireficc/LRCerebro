class AddGoogleCalendarAttributesToStandardReservation < ActiveRecord::Migration
    def change
        add_column :standard_reservations, :google_calendar_event_id, :string
        add_column :standard_reservations, :google_calendar_html_link, :string
    end
end