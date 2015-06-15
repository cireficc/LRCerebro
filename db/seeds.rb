# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
    User.create(username: 'director', g_number: 'g00000000', password: 'director', first_name: 'Director', last_name: 'MLL', role: 'director')
    User.create(username: 'labasst', g_number: 'g00000000', password: 'labasst', first_name: 'Labasst', last_name: 'MLL', role: 'labasst')
    User.create(username: 'faculty', g_number: 'g00000000', password: 'faculty', first_name: 'Faculty', last_name: 'MLL', role: 'faculty')
    User.create(username: 'student', g_number: 'g00000000', password: 'student', first_name: 'Student', last_name: 'MLL', role: 'student')