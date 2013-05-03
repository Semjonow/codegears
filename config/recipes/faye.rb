require "bundler/capistrano"

set :faye_pid,    "#{current_path}/tmp/pids/faye.pid"
set :faye_config, "faye.ru"

namespace :faye do
  desc "Start Faye"
  task :start do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rackup #{faye_config} -s thin -E production -D --pid #{faye_pid}"
  end

  desc "Stop Faye"
  task :stop do
    run "kill `cat #{faye_pid}` || true"
  end
  before "deploy:update_code", "faye:stop"
  after  "deploy:cleanup",     "faye:start"
end