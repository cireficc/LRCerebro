mll_data_directory = Rails.root.join('db', 'MLL_data')
lrc_ppl = mll_data_directory.join('lrc_ppl.txt')
lrc_crs = mll_data_directory.join('lrc_crs.txt')
lrc_enr = mll_data_directory.join('lrc_enr.txt')

puts "Seeding production (using MLL data from Blackboard)..."
puts "The files: lrc_ppl.txt, lrc_crs.txt and lrc_enr.txt must be located in: #{mll_data_directory}..."
puts "NOTE: the directory /db/MLL_data is not (and should not) be checked into Git."

require 'csv'

puts "\n"
puts "Importing students and faculty from lrc_ppl.txt..."

# After import, we use these two arrays to remove users that are no longer active in MLL courses
@imported_users = Array.new # The list of users being imported from the CSV file
@existing_users = User.all # The current users in the database

# Iterate through all of the MLL faculty/students
CSV.foreach(lrc_ppl, col_sep: '|', headers: false).each_with_index do |row, i|
	
	# Format: g_number|username|first_name|last_name|role
	# e.g. G00000000|cireficc|Chris|Cirefice|STUDENT
  
	g_number = row[0].downcase
	username = row[1]
	first_name = row[2]
	last_name = row[3]
	role = row[4].downcase
	# Convert the string to our User.role's enum value
	role = User.roles[role]
	
	@user = User.find_by(g_number: g_number)
	@user = User.create(username: username, g_number: g_number, first_name: first_name, last_name: last_name, role: role) if @user.nil?
	
	@imported_users << @user
	
	print "." if (i % 25 == 0)
end

puts "\n"
# Get a list of users that were in the database before import, but were not in the CSV, and delete them
@users_to_delete = @existing_users - @imported_users
@users_to_delete.each do |u|
	u.courses.delete_all # Remove all courses from the user before deleting to keep the join table clean
	u.delete
end

puts "\n"
puts "Importing courses from lrc_crs.txt..."

# After import, we use these two arrays to remove courses that are no longer available (however unlikely that is)
@imported_courses = Array.new # The list of courses being imported from the CSV file
@existing_courses = Course.all # The current courses in the database

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
	department = Course::DEPARTMENT_CODES[language] # Gives us the actual enum value
	course_number = identifier[3..5].to_i # Course number is the next 3 digits of the identifier
	section = identifier[7..8].to_i # Section number is the last 2 digits of the identifier
	
	@course = Course.find_by(id: course_id)
	
	@course = Course.create(year: year, semester: semester, department: department, course: course_number, section: section, name: name) if @course.nil?
	# Overwrite the serially-set id for the course with the id from Blackboard
	@course.id = course_id
	@course.save!
	
	@imported_courses << @course
	
	print "." if (i % 25 == 0)
end

puts "\n"
# Get a list of courses that were in the database before import, but were not in the CSV, and delete them
@courses_to_delete = @existing_courses - @imported_courses
@courses_to_delete.each do |c|
	c.users.delete_all # Remove all users from the course before deleting to keep the join table clean
	c.delete
end

puts "\n"
puts "Importing enrollments from lrc_enr.txt..."

# Iterate through all of the MLL enrollment data
CSV.foreach(lrc_enr, col_sep: '|', headers: false).each_with_index do |row, i|
	
	course_id = row[0].to_i
	g_number = row[1].downcase
	
	if @course && @course.id != course_id
		@course = Course.find_by_id(course_id)
	end
	
	@user = User.find_by(g_number: g_number)
	
	@course.users << @user if @user && @course
	
	print "." if (i % 25 == 0)
end
puts "\n"