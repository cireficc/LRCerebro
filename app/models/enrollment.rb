class Enrollment < ActiveRecord::Base

    belongs_to :course
    belongs_to :user, foreign_key: :user_id, primary_key: :g_number
end