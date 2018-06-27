module AsanaHelper
	include ApplicationHelper

	LRC_WORKSPACE_ID = Rails.application.secrets.asana_lrc_workspace_id
	LRCEREBRO_PROJECT_ID = Rails.application.secrets.asana_lrcerebro_project_id
	PROJECT_PUBLISHING_PROJECT_ID = Rails.application.secrets.asana_project_publishing_project_id
	MINI_PROJECTS_PROJECT_ID = Rails.application.secrets.asana_mini_projects_project_id
	FILM_DIGITIZATIONS_PROJECT_ID = Rails.application.secrets.asana_film_digitizations_project_id
	VIDCAM_FILMING_PROJECT_ID = Rails.application.secrets.asana_vidcam_filming_project_id
	VIDCAM_PUBLISHING_PROJECT_ID = Rails.application.secrets.asana_vidcam_publishing_project_id
	WORK_REQUESTS_PROJECT_ID = Rails.application.secrets.asana_work_requests_project_id

	TAG_TASK_ID = Rails.application.secrets.asana_lrcerebro_tag_task_id

	TAG_TASK_CREATE_DATA = {
			projects: [LRCEREBRO_PROJECT_ID],
			name: '[DO NOT MODIFY/DELETE] Tag Task',
			notes: 'This task is created and maintained by LRCerebro. Do not modify or delete this task, or course/instructor tags will stop working properly in Asana!'
	}

	# List all subtasks, but reverse them since Asana lists the most-recently-created on the top of the list
	FILM_CATALOGING_SUBTASKS = [
			'Create film entry in LRCerebro',
			'Rip with MacTheRipper',
			'Convert to mp4 with Handbrake (H.264)',
			'Add digitized version for the film in LRCerebro',
			'Rename file with LRCerebro-generated name',
			'Upload file to Panopto',
			'Add file to media server',
			'Email faculty',
			'Label DVD case with LRCerebro-generated catalog #',
			'Put DVD in Gem Track'
	].reverse
	
	FILM_DIGITIZATION_SUBTASKS = FILM_CATALOGING_SUBTASKS[2..-2]

	@client = Asana::Client.new do |c|
		c.authentication :access_token, Rails.application.secrets.asana_personal_access_token
	end

	def self.create_project_task(project)

		project = project.decorate

		notes = "Type: #{project.category}
Name: #{project.name}
Description: #{project.description}
Due Date: #{project.due}
Publish By: #{project.publish_by}
Publish Method(s): #{project.stringified_publish_methods}
Submitted: #{ApplicationHelper.utc_to_local(project.created_at)}"

		task_data = {
				projects: [PROJECT_PUBLISHING_PROJECT_ID],
				name: "Project Publishing: #{project.category} (#{project.name})",
				due_at: ApplicationHelper.local_to_utc(project.publish_by),
				notes: notes
		}

		task = @client.tasks.create(task_data)
		existing_tags = get_all_workspace_tags
		create_and_attach_tag(existing_tags, task, project.course.decorate.short_name)
		create_and_attach_tag(existing_tags, task, project.course.instructor.last_name)
	end

	def self.create_mini_project_task(mini_project)

		mini_project = mini_project.decorate

		notes = "Resources: #{mini_project.stringified_resources}
Description: #{mini_project.description}
Supplemental Materials: #{mini_project.supplemental_materials_description}
Start Date: #{mini_project.start_date}
Due Date: #{mini_project.due_date}
Publish By: #{mini_project.publish_by}
Publish Method(s): #{mini_project.stringified_publish_methods}
Submitted: #{ApplicationHelper.utc_to_local(mini_project.created_at)}"

		task_data = {
				projects: [MINI_PROJECTS_PROJECT_ID],
				name: "Mini Project: #{mini_project.stringified_resources}",
				due_at: ApplicationHelper.local_to_utc(mini_project.publish_by),
				notes: notes
		}

		task = @client.tasks.create(task_data)
		existing_tags = get_all_workspace_tags
		create_and_attach_tag(existing_tags, task, mini_project.course.decorate.short_name)
		create_and_attach_tag(existing_tags, task, mini_project.course.instructor.last_name)
	end

	def self.create_film_digitization_task(film_digitization)

		film_digitization = film_digitization.decorate

		notes = "Film Source: #{film_digitization.media_source}
Film: #{film_digitization.full_title}
Audio Language: #{film_digitization.audio_language.titleize}
Subtitle Language: #{film_digitization.subtitle_language.titleize}
Submitted: #{ApplicationHelper.utc_to_local(film_digitization.created_at)}"

		task_data = {
				projects: [FILM_DIGITIZATIONS_PROJECT_ID],
				name: "Film Digitization Request: #{film_digitization.full_title}",
				due_at: ApplicationHelper.local_to_utc(film_digitization.due_date),
				notes: notes
		}

		task = @client.tasks.create(task_data)
		existing_tags = get_all_workspace_tags
		create_and_attach_tag(existing_tags, task, film_digitization.course.decorate.short_name)
		create_and_attach_tag(existing_tags, task, film_digitization.course.instructor.last_name)

		FILM_DIGITIZATION_SUBTASKS.each do |subtask|
			task.add_subtask({name: subtask})
		end
	end

	def self.create_vidcam_task(vidcam)

		vidcam = vidcam.decorate

		filming_notes = "Location: #{vidcam.location}
Start: #{vidcam.start}
End: #{vidcam.end}
Additional Instructions: #{vidcam.additional_instructions}
Submitted: #{ApplicationHelper.utc_to_local(vidcam.created_at)}"

		filming_task_data = {
				projects: [VIDCAM_FILMING_PROJECT_ID],
				name: "Vidcam Filming: #{vidcam.location}",
				due_at: ApplicationHelper.local_to_utc(vidcam.publish_by),
				notes: filming_notes
		}

		publishing_notes = "Additional Instructions: #{vidcam.additional_instructions}
Publish By: #{vidcam.publish_by}
Upload to Ensemble: #{vidcam.upload_to_ensemble_string}
Publish Methods: #{vidcam.stringified_publish_methods}
Submitted: #{ApplicationHelper.utc_to_local(vidcam.created_at)}"

		publishing_task_data = {
				projects: [VIDCAM_PUBLISHING_PROJECT_ID],
				name: "Vidcam Publishing: #{vidcam.location}",
				due_at: ApplicationHelper.local_to_utc(vidcam.publish_by),
				notes: publishing_notes
		}

		filming_task = @client.tasks.create(filming_task_data)
		publishing_task = @client.tasks.create(publishing_task_data)
		existing_tags = get_all_workspace_tags
		create_and_attach_tag(existing_tags, filming_task, vidcam.course.decorate.short_name)
		create_and_attach_tag(existing_tags, filming_task, vidcam.course.instructor.last_name)
		create_and_attach_tag(existing_tags, publishing_task, vidcam.course.decorate.short_name)
		create_and_attach_tag(existing_tags, publishing_task, vidcam.course.instructor.last_name)
	end

	def self.create_work_task(work)

		task_data = {
				projects: [WORK_REQUESTS_PROJECT_ID],
				name: 'Work Request',
				due_at: ApplicationHelper.local_to_utc(work.due_date),
				notes: "#{work.instructions}\n\nSubmitted: #{ApplicationHelper.utc_to_local(work.created_at)}"
		}

		task = @client.tasks.create(task_data)
		existing_tags = get_all_workspace_tags
		create_and_attach_tag(existing_tags, task, work.course.decorate.short_name)
		create_and_attach_tag(existing_tags, task, work.course.instructor.last_name)
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

	def self.get_all_workspaces
		ws = @client.workspaces.find_all
		ws.each do |w|
			puts w.inspect
		end
		ws
	end

	def self.get_all_projects
		projects = @client.projects.find_all(workspace: LRC_WORKSPACE_ID)
		projects.each do |p|
			puts p.inspect
		end
		projects
	end

	def self.get_all_tasks(project_id)
		tasks = @client.tasks.find_all(project: project_id, completed_since: 'now')
		tasks.each do |t|
			t = @client.tasks.find_by_id(t.id)
			puts t.inspect
		end
		tasks
	end

	def self.get_all_workspace_tags
		tags = @client.tags.find_all(workspace: LRC_WORKSPACE_ID)
		tags.sort_by(&:name)
	end
end
