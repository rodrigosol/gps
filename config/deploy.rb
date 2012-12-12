set :default_environment, {
  'PATH' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194/bin:/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global/bin:/home/ubuntu/.rvm/rubies/ruby-1.9.3-p194/bin:/home/ubuntu/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games",
  'RUBY_VERSION' => '1.9.3p194',
  'GEM_HOME' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194",
  'GEM_PATH' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194:/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global",
  'LANG' => 'en_US.UTF-8'
}

set :application, "gps"
set :repository,  "git@github.com:rarolabs/gps.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "Apache"                          # Your HTTP server, Apache/etc
# role :app, "Web"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :stages, %w(production staging)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
#require './config/boot'


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end