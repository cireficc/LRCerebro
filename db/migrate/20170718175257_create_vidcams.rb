class CreateVidcams < ActiveRecord::Migration
  def change
    create_table :vidcams do |t|
      t.belongs_to :course
      t.string :location
      t.datetime :start
      t.datetime :end
      t.datetime :publish_by
      t.boolean :upload_to_ensemble
      t.text :publish_methods, array: true, default: []
      t.text :additional_instructions
      t.timestamps null: false
    end
  end
end
