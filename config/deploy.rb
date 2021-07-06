# config valid only for current version of Capistrano
lock "3.16.0"

set :application, "lrcerebro"
set :repo_url, "https://github.com/cireficc/LRCerebro.git"

# Set the default stage to production as staging is not generally accessible.
set :stage, "production"

set :chruby_ruby, "ruby-2.5.1"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/app/lrcerebro"

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(
  "config/application.yml",
  "config/GOOGLE_API_SERVICE_PRODUCTION.json",
  "config/cloudinary.yml"
)

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  "log",
  "tmp/pids",
  "tmp/cache",
  "tmp/sockets",
  "vendor/bundle",
  "public/system",
)

namespace :deploy do
  # Set the ruby version in ~lrcerbro/.ruby-version so that when the user logs
  # in they are automatically using the correct version of Ruby for the app.
  after :restart, :set_ruby_version do
    on roles(:all) do
      data = StringIO.new("#{fetch(:chruby_ruby)}\n")
      path = File.join(deploy_to, ".ruby-version")

      upload!(data, path)
    end
  end

  # Delayed Job runs background jobs (like syncing data from Google) and needs
  # to be restarted after each code deploy.
  after :restart, :restart_delayed_job do
    on roles(:all) do
      execute "sudo /usr/sbin/service lrcerebro-delayed-job restart"
    end
  end
end
