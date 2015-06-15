# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
    User.create(username: 'cireficc', g_number: 'g00749804', password: 'chris', first_name: 'Chris', last_name: 'Cirefice', role: 'labasst')
    User.create(username: 'timmerk', g_number: 'g00000000', password: 'kevin', first_name: 'Kevin', last_name: 'Timmer', role: 'director')