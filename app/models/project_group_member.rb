class ProjectGroupMember < ActiveRecord::Base
    belongs_to :project_group
    belongs_to :user
end
