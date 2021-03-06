puts "Seeding development..."

IMAGE_PATH = Rails.root.join('db', 'seeds', 'images')
YEAR = Time.now.year

# Seed for the site configuration
ApplicationConfiguration.create!(enrollment_update_message: "Enrollment", enrollment_last_updated: Date.yesterday,
                                 current_semester_start: 3.days.ago, current_semester_end: Time.now + 20.days, current_semester_year: YEAR, current_semester: 0,
                                 class_project_submission_start: 2.days.ago, class_project_submission_end: Time.now + 10.days,
                                 class_project_before_deadline_message: "Project deadline approaching", class_project_after_deadline_message: "Project deadline passed")

Film.create!(film_type: 2, english_title: "Alice in Wonderland", foreign_title: "Alice au pays des merveilles", transliterated_foreign_title: "Alice au pays des merveilles",
             description: "Alice stumbles into the world of Wonderland. Will she get home? Not if the Queen of Hearts has her way.",
             audio_languages: ["english", "french"], subtitle_languages: ["english", "french"], year: 1951, length: 75, mpaa_rating: 0,
             director_list: ["Clyde Geronimi", "Wilfred Jackson", "Hamilton Luske"], cast_member_list: ["Kathryn Beaumont", "Ed Wynn", "Richard Haydn"], genre_list: ["Animation", "Adventure", "Family"],
             cover: File.open(File.join(IMAGE_PATH, 'Alice au pays des merveilles.jpg')), more_info_link: "http://www.imdb.com/title/tt0043274/")
Film.create!(film_type: 2, english_title: "Finding Nemo", foreign_title: "Findet Nemo", transliterated_foreign_title: "Findet Nemo",
             description: "After his son is captured in the Great Barrier Reef and taken to Sydney, a timid clownfish sets out on a journey to bring him home.",
             audio_languages: ["english", "german"], subtitle_languages: ["english", "german"], year: 2003, length: 100, mpaa_rating: 0,
             director_list: ["Andrew Stanton", "Lee Unkrich"], cast_member_list: ["Albert Brooks", "Ellen DeGeneres", "Alexander Gould"], genre_list: ["Animation", "Adventure", "Comedy"],
             cover: File.open(File.join(IMAGE_PATH, 'Findet Nemo.jpg')), more_info_link: "http://www.imdb.com/title/tt0266543/")
Film.create!(film_type: 2, english_title: "The Lion King", foreign_title: "El Rey Leon", transliterated_foreign_title: "El Rey Leon",
             description: "Lion cub and future king Simba searches for his identity. His eagerness to please others and penchant for testing his boundaries sometimes gets him into trouble.",
             audio_languages: ["english", "spanish"], subtitle_languages: ["english", "spanish"], year: 1994, length: 89, mpaa_rating: 0,
             director_list: ["Roger Allers", "Rob Minkoff"], cast_member_list: ["Matthew Broderick", "Jeremy Irons", "James Earl Jones"], genre_list: ["Animation", "Adventure", "Drama"],
             cover: File.open(File.join(IMAGE_PATH, 'El Rey Leon.jpg')), more_info_link: "http://www.imdb.com/title/tt0110357/")
el_rey_leon = Film.create!(film_type: 2, english_title: "Life Is Beautiful", foreign_title: "La vita è bella", transliterated_foreign_title: "La vita e bella",
             description: "When an open-minded Jewish librarian and his son become victims of the Holocaust, he uses a perfect mixture of will, humor and imagination to protect his son from the dangers around their camp.",
             audio_languages: ["english", "italian"], subtitle_languages: ["english", "italian"], year: 1997, length: 116, mpaa_rating: 2,
             director_list: ["Roberto Benigni"], cast_member_list: ["Roberto Benigni", "Nicoletta Braschi", "Giorgio Cantarini"], genre_list: ["Comedy", "Drama", "Romance"],
             cover: File.open(File.join(IMAGE_PATH, 'La vita e bella.jpg')), more_info_link: "http://www.imdb.com/title/tt0118799/")
Film.create!(film_type: 2, english_title: "Princess Mononoke", foreign_title: "もののけ姫", transliterated_foreign_title: "Mononoke-hime",
             description: "On a journey to find the cure for a Tatarigami's curse, Ashitaka finds himself in the middle of a war between the forest gods and Tatara, a mining colony. In this quest he also meets San, the Mononoke Hime.",
             audio_languages: ["english", "japanese"], subtitle_languages: ["english", "japanese"], year: 1997, length: 134, mpaa_rating: 2,
             director_list: ["Hayao Miyazaki"], cast_member_list: ["Yôji Matsuda", "Yuriko Ishida", "Yûko Tanaka"], genre_list: ["Animation", "Adventure", "Fantasy"],
             cover: File.open(File.join(IMAGE_PATH, 'Mononoke-hime.jpg')), more_info_link: "http://www.imdb.com/title/tt0119698/")
Film.create!(film_type: 2, english_title: "Crouching Tiger, Hidden Dragon", foreign_title: "卧虎藏龙", transliterated_foreign_title: "Wo hu cang long",
             description: "Two warriors in pursuit of a stolen sword and a notorious fugitive are led to an impetuous, physically skilled, adolescent nobleman's daughter, who is at a crossroads in her life.",
             audio_languages: ["english", "chinese"], subtitle_languages: ["english", "chinese"], year: 2000, length: 120, mpaa_rating: 2,
             director_list: ["Ang Lee"], cast_member_list: ["Yun-Fat Chow", "Michelle Yeoh", "Ziyi Zhang"], genre_list: ["Action", "Drama", "Romance"],
             cover: File.open(File.join(IMAGE_PATH, 'Wo hu cang long.jpg')), more_info_link: "http://www.imdb.com/title/tt0190332/")
Film.create!(film_type: 2, english_title: "The Land", foreign_title: "الأرض", transliterated_foreign_title: "Al-ard",
             description: "A small peasant village's struggles against the careless inroads of the large local landowner, The Land shows why political oppression does not necessarily lead to a sense of solidarity among the disinherited.",
             audio_languages: ["english", "arabic"], subtitle_languages: ["english", "arabic"], year: 1969, length: 130, mpaa_rating: 5,
             director_list: ["Youssef Chahine"], cast_member_list: ["Hamdy Ahmed", "Yehia Chahine", "Ezzat El Alaili"], genre_list: ["Drama"],
             cover: File.open(File.join(IMAGE_PATH, 'Al-ard.png')), more_info_link: "http://www.imdb.com/title/tt0064038/")
Film.create!(film_type: 2, english_title: "The Cranes Are Flying", foreign_title: "Летят журавли", transliterated_foreign_title: "Letyat zhuravli",
             description: "Veronica plans a rendezvous with her lover, Boris, at the bank of river, only for him to be drafted into World War II shortly thereafter.",
             audio_languages: ["english", "russian"], subtitle_languages: ["english", "russian"], year: 1957, length: 97, mpaa_rating: 5,
             director_list: ["Mikhail Kalatozov"], cast_member_list: ["Tatyana Samoylova", "Aleksey Batalov", "Vasiliy Merkurev"], genre_list: ["Drama", "Romance", "War"],
             cover: File.open(File.join(IMAGE_PATH, 'Letyat zhuravli.jpg')), more_info_link: "http://www.imdb.com/title/tt0050634")
Film.create!(film_type: 2, english_title: "Knife in the Water", foreign_title: "Nóż w wodzie", transliterated_foreign_title: "Noz w wodzie",
             description: "On their way to a sailing trip, an aging husband and wife invite along an emphatic young hitchhiker out of sheer patronization.",
             audio_languages: ["english", "other"], subtitle_languages: ["english", "other"], year: 1962, length: 94, mpaa_rating: 5,
             director_list: ["Roman Polanski"], cast_member_list: ["Leon Niemczyk", "Jolanta Umecka", "Zygmunt Malanowicz"], genre_list: ["Drama", "Thriller"],
             cover: File.open(File.join(IMAGE_PATH, 'Noz w wodzie.jpg')), more_info_link: "http://www.imdb.com/title/tt0056291/")

# Create a few users to log in with and view/manipulate content with
director = User.create(username: 'director', pitm: 'DIRECTOR', password: 'director', first_name: 'Director', last_name: 'MLL', role: User.roles[:director], registered: true)
labasst = User.create(username: 'labasst', pitm: 'LABASST', password: 'labasst', first_name: 'Labasst', last_name: 'MLL', role: User.roles[:labasst], registered: true)
faculty = User.create(username: 'faculty', pitm: 'FACULTY', password: 'faculty', first_name: 'Faculty', last_name: 'MLL', role: User.roles[:faculty], registered: true)
student = User.create(username: 'student', pitm: 'STUDENT', password: 'student', first_name: 'Student', last_name: 'MLL', role: User.roles[:student], registered: true)
wardse = User.create(username: 'wardse', pitm: 'WARDSE', first_name: 'Séverine', last_name: 'Ward', role: User.roles[:faculty], registered: false)
fuchsk = User.create(username: 'fuchsk', pitm: 'FUCHSK', first_name: 'Kevin', last_name: 'Fuchs', role: User.roles[:faculty], registered: true)
cireficc = User.create(username: 'cireficc', pitm: 'CIREFICC', first_name: 'Chris', last_name: 'Cirefice', role: User.roles[:student], registered: false)
instructor_tbd = User.create(username: 'instructor_tbd', pitm: 'INSTRUCTOR_TBD', first_name: 'Instructor', last_name: 'TBD', role: User.roles[:faculty])

# Create a few courses for users to be enrolled in
spa = Course.create(year: YEAR, semester: 0, department: 7, course: 101, section: 01, name: 'SPA 101 01 - Elementary Spanish I')
spa.id = 12754
spa.save!
spa2 = Course.create(year: YEAR, semester: 0, department: 7, course: 102, section: 03, name: 'SPA 102 03 - Elementary Spanish II')
spa2.id = 12755
spa2.save!
fre = Course.create(year: YEAR, semester: 0, department: 2, course: 101, section: 01, name: 'FRE 101 01 - Elementary French I')
fre.id = 12775
fre.save!
fre2 = Course.create(year: YEAR, semester: 0, department: 2, course: 202, section: 02, name: 'FRE 202 02 - Intermediate French II')
fre2.id = 12776
fre2.save!
fre3 = Course.create(year: YEAR, semester: 0, department: 2, course: 307, section: 01, name: 'FRE 307 01 - Advanced French Grammar')
fre3.id = 12777
fre3.save!
lrc = Course.create(year: YEAR, semester: 0, department: 8, course: 100, section: 00, name: 'LRC 100 00 - Intro to LRC')

# Create the enrollments for users in courses
Enrollment.create!(user: faculty, course: spa, role: Enrollment.roles[:instructor])
Enrollment.create!(user: faculty, course: fre, role: Enrollment.roles[:instructor])
Enrollment.create!(user: student, course: spa, role: Enrollment.roles[:student])
Enrollment.create!(user: student, course: fre, role: Enrollment.roles[:student])
Enrollment.create!(user: wardse, course: fre2, role: Enrollment.roles[:instructor])
Enrollment.create!(user: wardse, course: fre3, role: Enrollment.roles[:instructor])
Enrollment.create!(user: fuchsk, course: spa2, role: Enrollment.roles[:instructor])
Enrollment.create!(user: cireficc, course: fre3, role: Enrollment.roles[:student])
Enrollment.create!(user: director, course: lrc, role: Enrollment.roles[:instructor])
Enrollment.create!(user: labasst, course: lrc, role: Enrollment.roles[:student])

3000.times do |i|
	u = User.create(username: i, pitm: i, first_name: "asdf #{i}", last_name: 'ghjk', role: User.roles[:student], registered: false)
	Enrollment.create(course: lrc, user: u, role: Enrollment.roles[:student])
end

# Create a few projects to assign to courses
spa_project_1 = Project.create!(course: spa, name: "SPA Project", description: "Camtasia description", category: "Camtasia", group_size: 3,
                                script_due: DateTime.new(YEAR, 8, 15, 7, 0, 0, '-5'), due: DateTime.new(YEAR, 8, 25, 16, 0, 0, '-5'),
                                publish_by: DateTime.new(YEAR, 8, 27, 13, 0, 0, '-5'), publish_methods: ['web_archive'], approved: false)
spa_project_2 = Project.create!(course: spa2, name: "Bienvenido", description: "Some type of Garage Band project", category: "Garage Band", group_size: 2,
                                script_due: DateTime.new(YEAR, 8, 17, 7, 0, 0, '-5'), due: DateTime.new(YEAR, 8, 29, 18, 0, 0, '-5'),
                                publish_by: DateTime.new(YEAR, 8, 30, 13, 0, 0, '-5'), publish_methods: ['web_archive'], approved: true)
spa_project_3 = Project.create!(course: spa2, name: "Muy Caliente", description: "Pixton project", category: "Pixton", group_size: 3,
                                script_due: DateTime.new(YEAR, 8, 11, 7, 0, 0, '-5'), due: DateTime.new(YEAR, 8, 24, 16, 0, 0, '-5'),
                                publish_by: DateTime.new(YEAR, 8, 26, 13, 0, 0, '-5'), publish_methods: ['google_drive_link_sent_to_you'], approved: false)
fre_project_1 = Project.create!(course: fre, name: "FRE Project 1", description: "Garage Band description", category: "Garage Band", group_size: 1,
                                script_due: DateTime.new(YEAR, 8, 13, 7, 0, 0, '-5'), due: DateTime.new(YEAR, 8, 23, 16, 0, 0, '-5'),
                                publish_by: DateTime.new(YEAR, 8, 25, 13, 0, 0, '-5'), publish_methods: ['google_drive_link_sent_to_you'], approved: false)
fre_project_2 = Project.create!(course: fre2, name: "FRE Project 2", description: "Pixton description", category: "Pixton", group_size: 2,
                                script_due: DateTime.new(YEAR, 8, 13, 7, 0, 0, '-5'), due: DateTime.new(YEAR, 8, 23, 16, 0, 0, '-5'),
                                publish_by: DateTime.new(YEAR, 8, 25, 13, 0, 0, '-5'), publish_methods: ['web_archive'], approved: true)
fre_project_3 = Project.create!(course: fre3, name: "FRE Project 3", description: "Camtasia awesomeness", category: "Camtasia", group_size: 2,
                                script_due: DateTime.new(YEAR, 8, 5, 7, 0, 0, '-5'), due: DateTime.new(YEAR, 8, 29, 16, 0, 0, '-5'),
                                publish_by: DateTime.new(YEAR, 8, 30, 13, 0, 0, '-5'), publish_methods: ['web_archive'], approved: false)

# Create some reservations for a project
training_1 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 17, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 17, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:a], category: ProjectReservation.categories[:training],
                                        subtype: ProjectReservation.subtypes[:project_introduction],
                                        staff_notes: "Set up Google Drive mini-presentation.", faculty_notes: "Help me with Google Drive please!")
training_2 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 18, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 18, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                        subtype: ProjectReservation.subtypes[:camera_training],
                                        staff_notes: "Reserve a camera and tripod 1 hour before reservation.", faculty_notes: "Camera training necessary.")
training_3 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 19, 6, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 19, 6, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                        staff_notes: "Make sure Pixton accounts are set up", faculty_notes: "Intro to Pixton")
training_4 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 19, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 19, 8, 15, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                        faculty_notes: "Intro to Garage Band")
training_5 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 7, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 7, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training])
training_6 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 9, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 9, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                        staff_notes: "No students have experience with Camtasia", faculty_notes: "Complete how-to is necessary.")
training_7 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 17, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 17, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:a], category: ProjectReservation.categories[:training],
                                        subtype: ProjectReservation.subtypes[:project_introduction],
                                        staff_notes: "Set up Google Drive mini-presentation.", faculty_notes: "Help me with Google Drive please!")
training_8 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 18, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 18, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                        subtype: ProjectReservation.subtypes[:camera_training],
                                        staff_notes: "Reserve a camera and tripod 1 hour before reservation.", faculty_notes: "Camera training necessary.")
training_9 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 19, 6, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 19, 6, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                        staff_notes: "Make sure Pixton accounts are set up", faculty_notes: "Intro to Pixton")
training_10 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 19, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 19, 8, 15, 0, '-5'),
                                         lab: Lab.locations[:b], category: ProjectReservation.categories[:training],
                                         faculty_notes: "Intro to Garage Band")
training_11 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 7, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 7, 7, 50, 0, '-5'),
                                         lab: Lab.locations[:b], category: ProjectReservation.categories[:training])
editing_1 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 19, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 19, 7, 50, 0, '-5'),
                                       lab: Lab.locations[:a], category: ProjectReservation.categories[:editing])
editing_2 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 20, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 20, 7, 50, 0, '-5'),
                                       lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])
editing_3 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 20, 6, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 20, 6, 50, 0, '-5'),
                                       lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])
editing_4 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 20, 5, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 20, 5, 50, 0, '-5'),
                                       lab: Lab.locations[:a], category: ProjectReservation.categories[:editing])
editing_5 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 21, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 21, 7, 50, 0, '-5'),
                                       lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])
editing_6 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 18, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 18, 7, 50, 0, '-5'),
                                       lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])
editing_7 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 19, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 19, 7, 50, 0, '-5'),
                                       lab: Lab.locations[:a], category: ProjectReservation.categories[:editing])
editing_8 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 20, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 20, 7, 50, 0, '-5'),
                                       lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])
editing_9 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 20, 6, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 20, 6, 50, 0, '-5'),
                                       lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])
editing_10 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 20, 5, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 20, 5, 50, 0, '-5'),
                                        lab: Lab.locations[:a], category: ProjectReservation.categories[:editing])
editing_11 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 21, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 21, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])
editing_12 = ProjectReservation.create!(start: DateTime.new(YEAR, 8, 18, 7, 0, 0, '-5'), end: DateTime.new(YEAR, 8, 18, 7, 50, 0, '-5'),
                                        lab: Lab.locations[:b], category: ProjectReservation.categories[:editing])

# Assign the reservations to the projects
spa_project_1.project_reservations << training_1 << training_2 << training_3 << editing_1 << editing_2
spa_project_2.project_reservations << training_4 << editing_6 << editing_5
spa_project_3.project_reservations << training_7 << training_9 << editing_7 << editing_8
fre_project_1.project_reservations << training_8 << training_10 << editing_3 << editing_9
fre_project_2.project_reservations << training_11 << editing_4 << editing_10
fre_project_3.project_reservations << training_5 << training_6 << editing_11 << editing_12

MiniProject.create!(course: spa, resources: ['Plex Music', 'Photobooth'], description: 'Students will listen to a song, learn it, then sing it and record with Photobooth.',
                    supplemental_materials: false, start_date: DateTime.new(YEAR, 9, 25, 5, 0, 0, '-5'), due_date: DateTime.new(YEAR, 9, 30, 5, 0, 0, '-5'), publish_by: DateTime.new(YEAR, 10, 2, 5, 0, 0, '-5'),
                    publish_methods: ['google_drive_link_sent_to_you'])
MiniProject.create!(course: fre, resources: ['Films', 'Google Drive/Docs'], description: 'Students will watch a French film and write a short summary of it.',
                    supplemental_materials: false, start_date: DateTime.new(YEAR, 10, 8, 5, 0, 0, '-5'), due_date: DateTime.new(YEAR, 10, 12, 5, 0, 0, '-5'), publish_by: DateTime.new(YEAR, 10, 17, 5, 0, 0, '-5'),
                    publish_methods: ['google_drive_link_sent_to_you'])

StandardReservation.create!(course: spa, activity: 'DiLL Paired (Synchronous) Recordings', start: DateTime.new(YEAR, 9, 6, 5, 0, 0, '-5'), end: DateTime.new(YEAR, 9, 6, 5, 50, 0, '-5'), lab: Lab.locations[:b],
                            walkthrough: true, utilities: ['sound_system'])
StandardReservation.create!(course: fre, activity: 'Writing or Web Research', start: DateTime.new(YEAR, 9, 6, 6, 0, 0, '-5'), end: DateTime.new(YEAR, 9, 6, 6, 50, 0, '-5'), lab: Lab.locations[:b],
                            walkthrough: true, utilities: ['projector'])

FilmDigitization.create!(course: spa, film: el_rey_leon, due_date: DateTime.new(YEAR, 10, 17, 5, 0, 0, '-5'), media_source: 'LRC film collection', audio_language: 'Spanish', subtitle_language: 'English')
FilmDigitization.create!(course: fre, due_date: DateTime.new(YEAR, 10, 28, 5, 0, 0, '-5'), media_source: 'Drop off at LRC Help Desk', film_title: 'Amélie', audio_language: 'French', subtitle_language: 'French')

Vidcam.create!(course: spa, location: 'Au Sable Hall 334', start: DateTime.new(YEAR, 9, 15, 5, 0, 0, '-5'), end: DateTime.new(YEAR, 9, 15, 5, 50, 0, '-5'), publish_by: DateTime.new(YEAR, 9, 20, 5, 0, 0, '-5'),
               publish_methods: ['google_drive_link_sent_to_you'], upload_to_ensemble: false, additional_instructions: 'Please record student presentations and edit them together into a single video.')
Vidcam.create!(course: fre, location: 'LRC', start: DateTime.new(YEAR, 9, 17, 5, 0, 0, '-5'), end: DateTime.new(YEAR, 9, 17, 5, 50, 0, '-5'), publish_by: DateTime.new(YEAR, 9, 18, 5, 0, 0, '-5'),
               publish_methods: ['google_drive_link_sent_to_you'], upload_to_ensemble: false, additional_instructions: 'Please record student interactions around Lab B when they are discussing their projects.')

Work.create!(course: spa, due_date: DateTime.new(YEAR, 9, 13, 5, 0, 0, '-5'), instructions: 'Please scan the short book that was dropped off to the LRC Help Desk.')
Work.create!(course: lrc, due_date: DateTime.new(YEAR, 9, 16, 5, 0, 0, '-5'), instructions: 'Add the new collection of graphic novels to the CMS inventory tool.')

puts "Done"