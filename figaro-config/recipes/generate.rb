node[:deploy].each do |app_name, deploy_config|
  # determine root folder of new app deployment
  app_root = "#{deploy_config[:deploy_to]}/current"
  
  execute "restart Rails app #{app_name}" do
    cwd deploy_config[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing #doesn't execute unless called/notified from another command
  end

  # use template .application.yml.erb. to generate 'config/application.yml'
  template "#{app_root}/config/application.yml" do
    source "application.yml.erb"
    cookbook "figaro-config"

    # set mode, group and owner of generated file
    mode "0660"
    group deploy_config[:group]
    owner deploy_config[:user]

    # define variable .@redis. to be used in the ERB template
    variables(
      :figaro => deploy_config[:figaro] || {}
    )
    
    notifies :run, "execute[restart Rails app #{app_name}]" #restart the rails app to update the config

    # only generate a file if there is Redis configuration
    not_if do
      deploy_config[:figaro].blank?
    end
  end
end