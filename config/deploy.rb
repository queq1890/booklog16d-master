# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "booklog16d"
set :repo_url, "git://github.com/queq1890/booklog16d-master.git"

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['/Users/yujimatsumoto/.ssh/first_key_tloz.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
  namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
