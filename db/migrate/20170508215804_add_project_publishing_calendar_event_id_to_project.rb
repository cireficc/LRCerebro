class AddProjectPublishingCalendarEventIdToProject < ActiveRecord::Migration[4.2]

def change
    add_column :projects, :google_calendar_publish_event_id, :string
  end
end
