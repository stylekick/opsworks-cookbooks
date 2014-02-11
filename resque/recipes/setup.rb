# Adapted from unicorn::rails: https://github.com/aws/opsworks-cookbooks/blob/master/unicorn/recipes/rails.rb

# include_recipe "resque::service"

# setup delayed_job service per app
node[:deploy].each do |application, deploy|
  
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping resque::setup application #{application} as it is not a Rails app")
    next
  end

  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end
  
  
  
  
  
  # Allow deploy user to restart workers
  
  # Chef::Log.debug("Creating sudoer for #{deploy[:user]}")
#   template "/etc/sudoers.d/#{deploy[:user]}" do
#     mode 0440
#     source "sudoer.erb"
#     variables :user => deploy[:user]
#   end
#   
#   template "#{node[:monit][:includes_dir]}/resque_#{application}.monitrc" do
#     mode 0644
#     source "resque.monitrc.erb"
#     variables(:deploy => deploy, :application => application, :resque => node[:resque][application])
#     
#     notifies :reload, resources(:service => "monit"), :immediately
#   end
  
end