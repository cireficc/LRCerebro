class CreateStandardReservations < ActiveRecord::Migration
    def change
        create_table :standard_reservations do |t|
            t.belongs_to :course
            t.integer :activity
            t.datetime :start
            t.datetime :end
            t.integer :lab
            t.boolean :walkthrough
            t.text :utilities, array: true, default: []
            t.text :assistances, array: true, default: []
            t.text :additional_instructions
            t.timestamps
        end
    end
end