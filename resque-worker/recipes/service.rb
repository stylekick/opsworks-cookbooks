node[:deploy].each do |application, deploy|
  
  # Overwrite the unicorn restart command declared elsewhere
  # Apologies for the `sleep`, but monit errors with "Other action already in progress" on some boots.
  execute "restart Rails app #{application}" do
    command "sleep 300 && #{node[:resque_worker][application][:restart_command]}"
    action :nothing
  end
  
  
end