# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, 'training'
set :repo_url, 'git@github.com:MLHustMaroon/training_app2.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
set :ssh_options, verify_host_key: :secure
puts 'deploy.rb file'
after 'deploy', 'deploy:cleanup'
desc 'symlink unicorn service'
task :setup_config do
  on release_roles :all do
    execute :sudo, :ln, "-nfs", "#{deploy_to}/current/config/unicorn/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    # run "ln #{deploy_to}/current/config/unicorn/unicorn_init.sh
    #       /etc/init.d/unicorn_#{:application}"
    # sudo "ln -nfs #{current_path}/shared/config/database.yml.example
    #       /#{current_path}/config/database.yml"
    # run "ln #{deploy_to}/current/shared/config/database.yml.example
    #   #{current_path}/config/database.yml"
    # run "cd #{deploy_to}/current && rails db:migrate"
    execute :sudo, :ln, "-nfs", "#{deploy_to}/current/shared/config/database.yml.example
      #{current_path}/config/database.yml"
    execute :cd, "#{deploy_to}/current"
    execute :rails, 'db:migrate'
  end
end
%w[start stop restart].each do |command|
  desc "#{command} unicorn server"
  task command do
    on primary roles :app do
      run "/ect/init.d/unicorn_#{application} #{command}"
    end
  end
end
after 'deploy:published', 'setup_config'
after 'deploy:published', 'restart'
