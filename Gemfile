source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.2'
# Use PostgreSQL as the database for ActiveRecord
gem 'pg', '~> 0.18.4'
# Use Devise as an authentication solution
gem 'devise', '~> 4.2'
# Use Bcrypt to encrypt passwords in the database
gem 'bcrypt', '~> 3.1.10'
# Use Pundit as a role-based resource restriction mechanism
gem 'pundit', '~> 1.0.1'
# Use Slim as the view templating engine (similar to Jade)
gem 'slim', '>= 3.0.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# Use Moment.js and Date-time picker for date/time selectors
gem 'momentjs-rails', '>= 2.9.0'
# https://github.com/TrevorS/bootstrap3-datetimepicker-rails
gem 'bootstrap3-datetimepicker-rails', '~> 4.7.14'
# Use Google Client Library for interaction with Google APIs (Calendar, Email, etc)
gem 'google-api-client', '~> 0.9'
# Use Simple Form for forms instead of building complex forms by hand
gem 'simple_form', '~> 3.2', '>= 3.2.1'
# Use Acts-As-Taggable-On for tagging models
gem 'acts-as-taggable-on', '~> 3.5'
# Use Select2 for tag multi-select
gem 'select2-rails', '~> 4.0.3'
# Use Searchkick (+ ElasticSearch) to complex searching
gem 'searchkick', '~> 1.3'
# Use Kaminari to paginate large result sets
gem 'kaminari', '~> 0.17.0'
# Use ActiveModelSerializers to succinctly customize JSON output
gem 'active_model_serializers', '~> 0.10.0'
# Use CarrierWave to do image attachments and processing, and Cloudinary to host them
gem 'carrierwave', '~> 0.11.2'
gem 'cloudinary', '~> 1.2'
# Use DataTables for table sorting
gem 'jquery-datatables-rails', '~> 3.4'
gem 'net-ldap'
# Use Cocoon for dynamic nested forms
gem 'cocoon', '~> 1.2.9'
# Use Draper for view-models (keep view code out of models)
gem 'draper', '~> 2.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
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
  gem "factory_girl"
  gem "database_cleaner"
end

group :staging, :production do
  # Change the logging output to use a structured logging format.
  gem "lograge"

  # V8 JavaScript Runtime for the server
  gem "therubyracer"
end
