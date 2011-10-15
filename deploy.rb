set :application, "Blurt Labs Marketplace"

set :scm, :none
set :repository, File.expand_path('output')

server "g", :app, :web, :db, :primary => true 

set :deploy_via, :copy
set :copy_exclude, [".git", ".DS_Store"] 
set :scm, :none
# set this path to be correct on yoru server
set :deploy_to, "/var/sites/maximeliron.com/blurt/marketplace" 
set :current_dir, 'demo'
set :use_sudo, false 
set :keep_releases, 100 


# this tells capistrano what to do when you deploy
namespace :deploy do 
 
  desc "A macro-task that updates the code and fixes the symlink."
  task :default do
    transaction do 
      update_code
      symlink
    end
  end
 
  task :update_code, :except => { :no_release => true } do 
    on_rollback { run "rm -rf #{release_path}; true" } 
    strategy.deploy! 
  end
 
  after 'deploy', 'cleanup'
end