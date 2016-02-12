puts "Rails environment for seeds: #{Rails.env.downcase}"

# Load the seed file in db/seeds with the name of the downcased environment variable
# Rails.env can be set on Linux via terminal: export RAILS_ENV=development|test|production
# Rails.env can be checked via terminal: echo $RAILS_ENV
ApplicationController::SEEDING_IN_PROGRESS = true
load(Rails.root.join( 'db', 'seeds', "#{Rails.env.downcase}.rb"))
ApplicationController::SEEDING_IN_PROGRESS = false