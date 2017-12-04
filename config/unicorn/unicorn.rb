rails_root = File.expand_path('../../', __FILE__)
rails_env = ENV['RAILS_ENV'] || 'production'
worker_processes 2
working_directory rails_root
listen "#{rails_root}/shared/sockets/unicorn.sock"
pid "#{rails_root}/shared/pids/unicorn.pid"
stderr_path "#{rails_root}/log/#{rails_env}_unicorn_error.log"
stdout_path "#{rails_root}/log/#{rails_env}_unicorn.log"