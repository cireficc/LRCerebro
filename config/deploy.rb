# config valid only for current version of Capistrano
lock "3.4.0"

set :application, "lrcerebro"
set :repo_url, "git@github.com:cireficc/LRCerebro.git"
set :branch, "capistrano"

set :chruby_ruby, "ruby-2.2.3"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/app/lrcerebro"

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(
  "config/application.yml",
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
end
