set :faye_pid, "#{current_path}/shared/pids/faye.pid"
set :faye_config, "#{current_path}/current/faye.ru"

namespace :faye do
  desc "Start Faye"
  task :start do
    run "cd #{current_path}/current && bundle exec rackup #{faye_config} -s thin -E production -D --pid #{faye_pid}"
  end

  desc "Stop Faye"
  task :stop do
    run "kill `cat #{faye_pid}` || true"
  end
end
before 'deploy:update_code', 'faye:stop'
after 'deploy:finalize_update', 'faye:start'