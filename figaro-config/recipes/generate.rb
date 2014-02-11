node[:deploy].each do |app_name, deploy_config|
  # determine root folder of new app deployment
  app_root = "#{deploy_config[:deploy_to]}/current"

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

    # only generate a file if there is Redis configuration
    not_if do
      deploy_config[:figaro].blank?
    end
  end
end