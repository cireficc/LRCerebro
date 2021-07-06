source 'https://rubygems.org'

#region [Core dependencies]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.6'
# Use PostgreSQL as the database for ActiveRecord
gem 'pg', '~> 1.2.3'
# Figaro handles configuration through environment variables.
gem 'figaro', '~> 1.2.0'
# Use Devise and Net-LDAP as an authentication solution
gem 'devise', '~> 4.8.0'
gem 'net-ldap', '~> 0.17.0'
# Use Bcrypt to encrypt passwords in the database
gem 'bcrypt', '~> 3.1.16'
# Use Pundit as a role-based resource restriction mechanism
gem 'pundit', '~> 2.1.0'
# Use DelayedJob and Daemons for job queue processing
gem 'delayed_job_active_record', '~> 4.1.6'
gem 'daemons', '~> 1.4.0'
# Use Simple Form for forms instead of building complex forms by hand
gem 'simple_form', '~> 5.1.0'
# Use Cocoon for dynamic nested forms
gem 'cocoon', '~> 1.2.15'
# Use Draper for view-models (keep view code out of models)
gem 'draper', '~> 4.0.2'
# Use Kaminari to paginate large result sets
gem 'kaminari', '~> 1.2.1'
# Use DataTables for table sorting
gem 'jquery-datatables-rails', '~> 3.4'
# Use ActiveModelSerializers to succinctly customize JSON output
gem 'active_model_serializers', '~> 0.10.12'
# Use Acts-As-Taggable-On for tagging models
# gem 'acts-as-taggable-on', '~> 5.0.0'
gem 'acts-as-taggable-on', git: 'https://github.com/mbleigh/acts-as-taggable-on.git'
# endregion

#region [Front-end dependencies]

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.4.0'
# Use Slim as the view templating engine (similar to Jade)
gem 'slim', '~> 4.1.0'
# Use Select2 for tag multi-select
gem 'select2-rails', '~> 4.0.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.7'
# Use Uglifier/ExecJS as compressor for JavaScript assets
gem 'uglifier', '~> 4.2.0'
gem 'execjs', '~> 2.8.1'
# V8 JavaScript Runtime for the server
gem 'mini_racer', '~> 0.4.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.2'
# Use Moment.js and Date-time picker for date/time selectors
gem 'momentjs-rails', '~> 2.20.1'
# https://github.com/TrevorS/bootstrap3-datetimepicker-rails
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'turbolinks', '~> 5.2.1'
# User Jquery-turbolinks to fix event binding problems for document ready
gem 'jquery-turbolinks', '~> 2.1.0'
#endregion

#region [3rd-party service integration dependencies]

# Use Searchkick (+ ElasticSearch) to complex searching
gem 'searchkick', '~> 4.5.0'
gem 'elasticsearch', '~> 7.13.1'
# Use Google Client Library for interaction with Google APIs (Calendar, Email, etc)
gem 'google-api-client', '~> 0.53.0'
# Use Asana for task management API access
gem 'asana', '~> 0.10.3'
# Use CarrierWave to do image attachments and processing, and Cloudinary to host them
gem 'carrierwave', '~> 2.2.2'
gem 'cloudinary', '~> 1.20.0'

#endregion

group :development do
  # Capistrano is our deployment tool of choice
  gem "capistrano-rails",         require: false
  gem "capistrano-chruby",        require: false
  gem "capistrano-bundler",       require: false
  gem "capistrano-passenger",     require: false
  gem "capistrano-rails-console", require: false

  # Support ed25519 ssh keys
  gem "bcrypt_pbkdf", require: false
  gem "ed25519",      require: false
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot"
  gem "database_cleaner"
end

group :staging, :production do
  # Change the logging output to use a structured logging format.
  gem 'lograge', '~> 0.11.2'
end

ruby '2.5.1'
