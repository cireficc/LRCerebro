# Create a few users to log in with and view/manipulate content with
User.create(username: 'director', g_number: 'g00000000', password: 'director', first_name: 'Director', last_name: 'MLL', role: User.roles[:director], registered: true)
User.create(username: 'labasst', g_number: 'g00000000', password: 'labasst', first_name: 'Labasst', last_name: 'MLL', role: User.roles[:labasst], registered: true)
faculty = User.create(username: 'faculty', g_number: 'g00000000', password: 'faculty', first_name: 'Faculty', last_name: 'MLL', role: User.roles[:faculty], registered: true)
student = User.create(username: 'student', g_number: 'g00000000', password: 'student', first_name: 'Student', last_name: 'MLL', role: User.roles[:student], registered: true)
User.create(username: 'unregistered', g_number: 'g00000000', password: 'unregistered', first_name: 'Unregistered', last_name: 'MLL', role: User.roles[:student], registered: false)

# Create a few courses for users to be enrolled in
spa = Course.create(year: 2015, semester: 0, department: 7, course: 101, section: 01, name: 'SPA 101 01 - Elementary Spanish I')
spa.id = 12754
spa.save!
fre = Course.create(year: 2015, semester: 0, department: 2, course: 101, section: 01, name: 'FRE 101 01 - Elementary French I')
fre.id = 12775
fre.save!

# Create a few projects to assign to courses
spa_project = Project.create(name: "SPA Project", description: "Camtasia description", category: Project.categories[:camtasia], num_groups: 5,
                                script_due: DateTime.new(2015,8,15,7,0,0,'-5'), due: DateTime.new(2015,8,25,16,0,0,'-5'),
                                viewable_by: DateTime.new(2015,8,27,13,0,0,'-5'), approved: false)
fre_project_1 = Project.create(name: "FRE Project 1", description: "Garage Band description", category: Project.categories[:garage_band], num_groups: 6,
                                script_due: DateTime.new(2015,8,13,7,0,0,'-5'), due: DateTime.new(2015,8,23,16,0,0,'-5'),
                                viewable_by: DateTime.new(2015,8,25,13,0,0,'-5'), approved: false)
fre_project_2 = Project.create(name: "FRE Project 2", description: "Pixton description", category: Project.categories[:pixton], num_groups: 3,
                                script_due: DateTime.new(2015,8,13,7,0,0,'-5'), due: DateTime.new(2015,8,23,16,0,0,'-5'),
                                viewable_by: DateTime.new(2015,8,25,13,0,0,'-5'), approved: true)
                            
# Create some reservations for a project
training_1 = ProjectReservation.create(start: DateTime.new(2015,8,17,7,0,0,'-5'), end: DateTime.new(2015,8,17,7,50,0,'-5'),
                                        lab: Lab.locations[:a], category: ProjectReservation.categories[:training],
                                        subtype: ProjectReservation.subtypes[:project_introduction],
                                        staff_notes: "Set up Google Drive mini-presentation.", faculty_notes: "Help me with Google Drive please!")
training_2 = ProjectReservation.create(start: DateTime.new(2015,8,18,7,0,0,'-5'), end: DateTime.new(2015,8,18,7,50,0,'-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                        subtype: ProjectReservation.subtypes[:camera_training],
                                        staff_notes: "Reserve a camera and tripod 1 hour before reservation.", faculty_notes: "Camera training necessary.")
editing_1 = ProjectReservation.create(start: DateTime.new(2015,8,19,7,0,0,'-5'), end: DateTime.new(2015,8,19,7,50,0,'-5'),
                                        lab: Lab.locations[:a], category: ProjectReservation.categories[:editing])
                                                    
# Assign the reservations to the project
spa_project.project_reservations << training_1 << training_2 << editing_1
                            
# Assign the projects to the courses
spa.projects << spa_project
fre.projects << fre_project_1 << fre_project_2

# Assigning the course to the faculty means that the faculty is also enrolled in the course
faculty.courses << spa << fre
student.courses << spa << fre
# Adding the faculty as a user of the course also triggers this relationship
#spa.users << faculty << student
#fre.users << faculty << student