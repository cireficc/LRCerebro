module AsanaHelper
	include ApplicationHelper

	LRC_WORKSPACE_ID = Rails.application.secrets.asana_lrc_workspace_id
	LRCEREBRO_PROJECT_ID = Rails.application.secrets.asana_lrcerebro_project_id
	TAG_TASK_ID = Rails.application.secrets.asana_lrcerebro_tag_task_id

	TAG_TASK_CREATE_DATA = {
			projects: [LRCEREBRO_PROJECT_ID],
			name: '[DO NOT MODIFY/DELETE] Tag Task',
			notes: 'This task is created and maintained by LRCerebro. Do not modify or delete this task, or course/instructor tags will stop working properly in Asana!'
	}

	@client = Asana::Client.new do |c|
		c.authentication :access_token, Rails.application.secrets.asana_personal_access_token
	end
	
	def self.update_tags
		begin
			tag_task = @client.tasks.find_by_id(TAG_TASK_ID)
		rescue Asana::Errors::NotFound
			tag_task = @client.tasks.create(TAG_TASK_CREATE_DATA)
		end

		puts "Tag task: #{tag_task.inspect}"

		existing_tags = get_all_workspace_tags
		puts "Existing workspace tags: #{existing_tags.count}"

		tag_names = existing_tags.collect(&:name)
		faculty = User.where(role: :faculty)
		courses = Course.active.decorate
		faculty_course_tags = (faculty.collect(&:last_name) + courses.collect(&:short_name))
		to_create = faculty_course_tags - tag_names

		to_create.each do |tag|
			puts "Adding tag ##{tag} to tag task"
			t = create_and_attach_tag(existing_tags, tag_task, tag)
			puts t
		end
	end

	def self.create_and_attach_tag(existing_tags, task, tag_name)

		t = get_tag_by_name(existing_tags, tag_name)
		t = @client.tags.create_in_workspace(workspace: LRC_WORKSPACE_ID, name: tag_name) if t.nil?

		task.add_tag(tag: t.id)
	end

	def self.get_tag_by_name(existing_tags, tag_name)
		matching = existing_tags.select {|t| t.name.casecmp?(tag_name)}
		matching.first if matching.any?
	end

	def self.show_all_workspaces
		ws = @client.workspaces.find_all
		ws.each do |w|
			puts w.inspect
		end
	end

	def self.show_all_tasks
		tasks = @client.tasks.find_all(project: LRCEREBRO_PROJECT_ID, completed_since: 'now')
		tasks.each do |t|
			t = @client.tasks.find_by_id(t.id)
		end
	end

	def self.get_all_workspace_tags
		tags = @client.tags.find_all(workspace: LRC_WORKSPACE_ID)
		tags.sort_by(&:name)
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
end