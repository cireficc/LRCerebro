class AddProjectPublishingCalendarEventIdToMiniProject < ActiveRecord::Migration
  def change
    add_column :mini_projects, :google_calendar_publish_event_id, :string
  end
end
