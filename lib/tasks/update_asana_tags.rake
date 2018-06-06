require 'asana'

namespace :asana do
	desc 'Updates tags in Asana for the new semester course/faculty data'
	task update_tags: :environment do

		LRC_WORKSPACE_ID = Rails.application.secrets.asana_lrc_workspace_id
		LRCEREBRO_PROJECT_ID = Rails.application.secrets.asana_lrcerebro_project_id
		TAG_TASK_ID = Rails.application.secrets.asana_lrcerebro_tag_task_id

		TAG_TASK_CREATE_DATA = {
				projects: [LRCEREBRO_PROJECT_ID],
				name: '[DO NOT MODIFY/DELETE] Tag Task',
				notes: 'This task is created and maintained by LRCerebro. Do not modify or delete this task, or tags will stop working in Asana!'
		}

		client = Asana::Client.new do |c|
			c.authentication :access_token, Rails.application.secrets.asana_personal_access_token
		end

		# Show all projects for a workspace
		# projects = client.projects.find_all(workspace: LRC_WORKSPACE_ID)
		# projects.each do |p|
		# 	puts p.inspect
		# end

		# Only show open tasks for a specific project
		# tasks = client.tasks.find_all(project: projects.first.id, completed_since: 'now')
		# tasks.each do |t|
		# 	puts t.inspect
		# end

		# # Get all tags for the workspace
		# tags = client.tags.find_all(workspace: lrc.id)
		# tags.each do |t|
		# 	puts t.inspect
		# end

		tag_task = client.tasks.find_by_id(TAG_TASK_ID)
		puts "Tag task: #{tag_task.inspect}"

		tags = tag_task.tags(per_page: 100)
		puts "Existing tag task tags: #{tags.count}"

		tag_names = tags.collect(&:name)
		faculty = User.where(role: :faculty)
		courses = Course.active.decorate
		faculty_course_tags = (faculty.collect(&:last_name) + courses.collect(&:short_name))
		to_create = faculty_course_tags - tag_names

		to_create.each do |tag|
			puts "Adding tag ##{tag} to tag task"
			t = client.tags.create_in_workspace(workspace: LRC_WORKSPACE_ID, name: tag)
			tag_task.add_tag(tag: t.id)
			puts t
		end
	end
end
