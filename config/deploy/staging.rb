set :default_environment, { 
  'PATH' => "/home/raro/.rvm/gems/ruby-1.9.2-p290/bin:/home/raro/.rvm/gems/ruby-1.9.2-p290@global/bin:/home/raro/.rvm/rubies/ruby-1.9.2-p290/bin:/home/raro/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games",
  'RUBY_VERSION' => '1.9.2p290',
  'GEM_HOME' => "/home/raro/.rvm/gems/ruby-1.9.2-p290",
  'GEM_PATH' => "/home/raro/.rvm/gems/ruby-1.9.2-p290:/home/raro/.rvm/gems/ruby-1.9.2-p290@global",
  'LANG' => 'en_US.UTF-8'
}

set :application, "BomDeVoto"
 
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/app/bom_de_voto"
 
# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true

set :scm, :git
set :repository, "git@github.com:rarolabs/Bom-de-Voto.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, 'raro'
set :ssh_options, { :forward_agent => true }
 
role :app, "184.106.146.93"
role :web, "184.106.146.93"
role :db,  "184.106.146.93", :primary => true



namespace :deploy do
    task :ln_assets do
      run <<-CMD
        rm -rf #{latest_release}/public/assets &&
        mkdir -p #{shared_path}/assets &&
        ln -s #{shared_path}/assets #{latest_release}/public/assets
      CMD
    end

    task :assets do
      update_code
      ln_assets
    
      run_locally "rake assets:precompile"
      run_locally "cd public; tar -zcvf assets.tar.gz assets"
      top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
      run "cd #{shared_path}; tar -zxvf assets.tar.gz"
      run_locally "rm public/assets.tar.gz"
      run_locally "rm -rf public/assets"
    
      create_symlink
      restart
    end
end


namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
#para rodar o bundle antes do assets https://github.com/capistrano/capistrano/issues/81
before "deploy", "deploy:assets"
#before "deploy:assets", :bundle_install
#desc "install the necessary prerequisites"
#task :bundle_install, :roles => :app do
#  run "cd #{release_path} && bundle install"
#end

#after 'deploy:update_code' do
#  run "cd #{release_path}; RAILS_ENV=production /home/raro/.rvm/wrappers/ruby-1.9.2-p290/rake assets:precompile"
#end