require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/mongodb"
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

set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.erb", __FILE__)

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"