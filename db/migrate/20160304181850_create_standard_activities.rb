class CreateStandardActivities < ActiveRecord::Migration
    def change
        create_table :standard_activities do |t|
            t.integer :activity
            t.datetime :start
            t.datetime :end
            t.integer :lab
            t.boolean :walkthrough
            t.text :utilities, array: true, default: []
            t.text :assistance, array: true, default: []
            t.text :additional_instructions
            t.timestamps
        end
    end
end