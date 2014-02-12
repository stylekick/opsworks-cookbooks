node[:deploy].each do |application, deploy|
  
  # Overwrite the unicorn restart command declared elsewhere
  # Apologies for the `sleep`, but monit errors with "Other action already in progress" on some boots.
  # execute "restart Rails app #{application}" do
#     command "sleep 300 && #{node[:resque_worker][application][:restart_command]}"
#     action :nothing
#   end
  
  execute 'stop resque' do
    action :nothing
  end

  execute 'start resque' do
    cwd deploy[:deploy_to] + "/current"
    command 'sudo QUEUE=* RAILS_ENV=production bundle exec rake resque:work'
  end

  execute 'restart resque' do
    action :nothing
  end


end