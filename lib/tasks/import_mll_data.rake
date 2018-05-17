require 'csv'

namespace :db do
	desc 'Imports MLL enrollment data from the Blackboard feed'
	task import_mll_data: :environment do
		mll_data_directory = Rails.root.join('..', 'lrc-feed')
		lrc_ppl = mll_data_directory.join('lrc_ppl.txt')
		lrc_crs = mll_data_directory.join('lrc_crs.txt')
		lrc_enr = mll_data_directory.join('lrc_enr.txt')

		log_file = File.open('mll_data_import_log.txt', 'w')
		log_file.puts "Log file for attempted MLL data import on #{Time.current.to_s}"
		log_file.puts
		log_file.puts 'Seeding production (using MLL data from Blackboard)...'
		log_file.puts "The files: lrc_ppl.txt, lrc_crs.txt and lrc_enr.txt must be located in: #{mll_data_directory}..."
		log_file.puts
		log_file.puts '[IMPORTING] students and faculty from lrc_ppl.txt...'
		log_file.puts

		# After import, we use these two arrays to remove users that are no longer active in MLL courses
		@imported_users = Array.new # The list of users being imported from the CSV file
		@existing_users = User.search('*', where: {archived: false}).to_a # The current users in the database that are not archived

		# Iterate through all of the MLL faculty/students
		CSV.foreach(lrc_ppl, col_sep: '|', headers: false).each_with_index do |row, i|

			# Format: pitm|username|first_name|last_name|role
			# e.g. 12345678|cireficc|Chris|Cirefice|STUDENT

			pitm = row[0]
			username = row[1]
			first_name = row[2]
			last_name = row[3]
			role = row[4].downcase
			# Convert the string to our User.role's enum value
			role = User.roles[role]

			@user = User.find_by(pitm: pitm)
			@user = User.create(username: username, pitm: pitm, first_name: first_name, last_name: last_name, role: role) if @user.nil?

			@imported_users << @user
		end

		log_file.puts 'DONE'
		log_file.puts
		log_file.puts '[IMPORTING] courses from lrc_crs.txt...'
		log_file.puts

		# After import, we use these two arrays to remove courses that are no longer available (however unlikely that is)
		@imported_courses = Array.new # The list of courses being imported from the CSV file
		@existing_courses = Course.active # The current courses in the database that are not archived

		# Iterate through all of the MLL courses
		CSV.foreach(lrc_crs, col_sep: '|', headers: false).each_with_index do |row, i|

			# Format: course_id|semester_code|identifier|name
			# e.g. 00000|201610|FRE100.01|FRE 100 01 - Imaginary French Course

			course_id = row[0]
			semester_code = row[1]
			identifier = row[2]
			name = row[3]

			year = semester_code[0..3].to_i # Year is the first 4 digits of the semester code
			semester = semester_code[4..5].to_i # Semester is the last 2 digits of the semester code
			semester = Course::SEMESTER_CODES[semester] # Gives us the actual enum value

			language = identifier[0..2] # Language is the first 3 characters of the identifier
			department = Course::DEPARTMENT_CODES[language] # Gives us the actual enum value, or nil
			department = Course.departments[:other] if department.nil? # if the code did not match a department, use 'other'
			course_number = identifier[3..5].to_i # Course number is the next 3 digits of the identifier
			section = identifier[7..8].to_i # Section number is the last 2 digits of the identifier

			@course = Course.find_by(id: course_id)

			@course = Course.create(year: year, semester: semester, department: department, course: course_number, section: section, name: name) if @course.nil?
			# Overwrite the serially-set id for the course with the id from Blackboard
			@course.id = course_id
			@course.save!

			@imported_courses << @course
		end

		log_file.puts 'DONE'
		log_file.puts
		log_file.puts '[IMPORTING] enrollments from lrc_enr.txt...'
		log_file.puts

		# After import is finished for a course, we use these two arrays to remove enrolls that no longer exist
		@imported_enrolls = Array.new
		@existing_enrolls = Array.new

		# Iterate through all of the MLL enrollment data
		CSV.foreach(lrc_enr, col_sep: '|', headers: false).each_with_index do |row, i|

			course_id = row[0].to_i
			pitm = row[1]
			role = row[2].downcase
			# Convert the string to our User.role's enum value
			role = Enrollment.roles[role]

			# If the course changed, delete the enrollments for the course where the user unenrolled
			# then reset the lists of imported enrolls and existing enrolls for the new course
			if @course && @course.id != course_id

				# Find the new course
				@course = Course.find_by_id(course_id)
				@imported_enrolls = Array.new # The list of enrolls being imported from the CSV file for this course
				@existing_enrolls = @course.users if @course # The current users enrolled in the course in the database
			end

			# Get the user that is about to be enrolled
			@user = User.find_by(pitm: pitm)

			# Only operate on the entry if the course exists and the user exists (they won't exist if deleted in the previous step(s))
			if @course && @user
				# If the user isn't already enrolled, actually add them to the course (we need to prevent duplicates)
				Enrollment.create(user: @user, course: @course, role: role) unless @existing_enrolls.include?(@user)
				@imported_enrolls << @user
			end
		end

		log_file.puts 'DONE'

		log_file.close
	end
end
