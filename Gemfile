source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.1'
# Use PostgreSQL as the database for ActiveRecord
gem 'pg', '~> 1.0.0'
# Use Devise as an authentication solution
gem 'devise', '~> 4.5.0'
# Use Bcrypt to encrypt passwords in the database
gem 'bcrypt', '~> 3.1.12'
# Use Pundit as a role-based resource restriction mechanism
gem 'pundit', '~> 1.0.1'
# Use Slim as the view templating engine (similar to Jade)
gem 'slim', '>= 4.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.2'
# Use Moment.js and Date-time picker for date/time selectors
gem 'momentjs-rails', '>= 2.9.0'
# https://github.com/TrevorS/bootstrap3-datetimepicker-rails
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
# Use Google Client Library for interaction with Google APIs (Calendar, Email, etc)
gem 'google-api-client', '~> 0.23.9'
# Use Simple Form for forms instead of building complex forms by hand
gem 'simple_form', '~> 4.0.1'
# Use Acts-As-Taggable-On for tagging models
# gem 'acts-as-taggable-on', '~> 5.0.0'
gem 'acts-as-taggable-on', git: 'https://github.com/mbleigh/acts-as-taggable-on.git'
# Use Select2 for tag multi-select
gem 'select2-rails', '~> 4.0.3'
# Use Searchkick (+ ElasticSearch) to complex searching
gem 'searchkick', '~> 3.0.2'
gem 'elasticsearch', '~> 6.0.3'
# Use Kaminari to paginate large result sets
gem 'kaminari', '~> 0.17.0'
# Use ActiveModelSerializers to succinctly customize JSON output
gem 'active_model_serializers', '~> 0.10.8'
# Use CarrierWave to do image attachments and processing, and Cloudinary to host them
gem 'carrierwave', '~> 0.11.2'
gem 'cloudinary', '~> 1.2'
# Use DataTables for table sorting
gem 'jquery-datatables-rails', '~> 3.4'
gem 'net-ldap'
# Use Cocoon for dynamic nested forms
gem 'cocoon', '~> 1.2.9'
# Use Draper for view-models (keep view code out of models)
gem 'draper', '~> 3.0.1'
# Use Asana for task management API access
gem 'asana', '~> 0.6.3'
# Use DelayedJob and Daemons for job queue processing
gem 'delayed_job_active_record', '~> 4.1.3'
gem 'daemons', '~> 1.2.6'
# Use Capistrano/DJ deploy library to properly set up Rake tasks
gem 'capistrano3-delayed-job', '~> 1.7.5'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5'
# User Jquery-turbolinks to fix event binding problems for document ready
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Figaro handles configuration through environment variables.
gem "figaro"

group :development do
  # Capistrano is our deployment tool of choice
  gem "capistrano-rails",         require: false
  gem "capistrano-chruby",        require: false
  gem "capistrano-bundler",       require: false
  gem "capistrano-passenger",     require: false
  gem "capistrano-rails-console", require: false
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot"
  gem "database_cleaner"
end

group :staging, :production do
  # Change the logging output to use a structured logging format.
  gem "lograge"

  # V8 JavaScript Runtime for the server
  gem "therubyracer"
end

ruby '2.5.1'