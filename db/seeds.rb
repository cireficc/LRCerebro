# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
    User.create(username: 'director', g_number: 'g00000000', password: 'director', first_name: 'Director', last_name: 'MLL', role: 'director')
    User.create(username: 'labasst', g_number: 'g00000000', password: 'labasst', first_name: 'Labasst', last_name: 'MLL', role: 'labasst')
    faculty = User.create(username: 'faculty', g_number: 'g00000000', password: 'faculty', first_name: 'Faculty', last_name: 'MLL', role: 'faculty')
    student = User.create(username: 'student', g_number: 'g00000000', password: 'student', first_name: 'Student', last_name: 'MLL', role: 'student')
    
    spa = Course.create(year: 2015, semester: 0, department: 7, course: 101, section: 01, name: 'SPA 101 01 - Elementary Spanish I')
    spa.id = 12754
    spa.save!
    fra = Course.create(year: 2015, semester: 0, department: 2, course: 101, section: 01, name: 'FRE 101 01 - Elementary French I')
    fra.id = 12775
    fra.save!
    # Assigning the course to the faculty means that the faculty is also enrolled in the course
    faculty.courses << spa << fra # << is the array append operator, chain it
    student.courses << spa << fra
    # Adding the faculty as a user of the course also triggers this relationship
    #spa.users << faculty << student
    #fra.users << faculty << student