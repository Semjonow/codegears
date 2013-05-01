require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/mongodb"
load "config/recipes/faye"
load "config/recipes/redis"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "173.255.229.72", :web, :app, :db, primary: true

set :user,        "codegears"
set :application, "codegears"
set :deploy_to,   "/home/#{user}/apps/#{application}"
set :deploy_via,  :remote_cache
set :use_sudo,    false

set :scm,        "git"
set :repository, "git@github.com:Semjonow/#{application}.git"
set :branch,     "master"

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"

def press_enter( ch, stream, data)
  if data =~ /Press.\[ENTER\].to.continue/
    ch.send_data("\n")
  else
    Capistrano::Configuration.default_io_proc.call(ch, stream, data)
  end
end