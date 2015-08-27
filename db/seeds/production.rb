mll_data_directory = Rails.root.join('db', 'MLL_data')
lrc_ppl = mll_data_directory.join('lrc_ppl.txt')
lrc_crs = mll_data_directory.join('lrc_crs.txt')
lrc_enr = mll_data_directory.join('lrc_enr.txt')

puts "Seeding production (using MLL data from Blackboard)..."
puts "The files: lrc_ppl.txt, lrc_crs.txt and lrc_enr.txt must be located in: #{mll_data_directory}..."
puts "NOTE: the directory /db/MLL_data is not (and should not) be checked into Git."

require 'csv'

# Iterate through all of the MLL faculty/students
CSV.foreach(lrc_ppl, col_sep: '|', headers: false) do |row|
  
	g_number = row[0]
	username = row[1]
	first_name = row[2]
	last_name = row[3]
	role = row[4]
	# Convert the string to our User.role's enum value
	role = User.roles[role.downcase]
end

# Iterate through all of the MLL courses
CSV.foreach(lrc_crs, col_sep: '|', headers: false) do |row|
	
	course_id = row[0]
	semester_code = row[1]
	identifier = row[2]
	name = row[3]
end

# Iterate through all of the MLL enrollment data
CSV.foreach(lrc_enr, col_sep: '|', headers: false) do |row|
	
	course_id = row[0]
	g_number = row[1]
end