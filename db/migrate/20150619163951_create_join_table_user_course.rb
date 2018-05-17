class CreateJoinTableUserCourse < ActiveRecord::Migration[4.2]

def change
    create_join_table :users, :courses do |t|
      t.index [:user_id, :course_id]
      t.index [:course_id, :user_id]
    end
  end
end
