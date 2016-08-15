class ProjectGroup < ActiveRecord::Base
    belongs_to :project
    has_many :project_group_members, dependent: :destroy
    has_many :users, through: :project_group_members
end
