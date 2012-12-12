set :default_environment, { 
  'PATH' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194/bin:/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global/bin:/home/ubuntu/.rvm/rubies/ruby-1.9.3-p194/bin:/home/ubuntu/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games",
  'RUBY_VERSION' => '1.9.3p194',
  'GEM_HOME' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194",
  'GEM_PATH' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194:/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global",
  'LANG' => 'en_US.UTF-8'
}

set :application, "BomDeVoto"
 
set :deploy_to, "/app/bom_de_voto"
 
default_run_options[:pty] = true

set :scm, :git
set :repository, "git@github.com:rarolabs/Bom-de-Voto.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, 'ubuntu'
set :ssh_options, { :forward_agent => true }
 
role :app, "177.71.248.233"
role :web, "177.71.248.233"
role :db,  "177.71.248.233", :primary => true



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