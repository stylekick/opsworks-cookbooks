node[:deploy].each do |app_name, deploy_config|
  # determine root folder of new app deployment
  app_root = "#{deploy_config[:deploy_to]}/current"

  # use template .cache.yml.erb. to generate 'config/cache.yml'
  template "#{app_root}/config/cache.yml" do
    source "cache.yml.erb"
    cookbook "memcached-config"

    # set mode, group and owner of generated file
    mode "0660"
    group deploy_config[:group]
    owner deploy_config[:user]

    # define variable .@redis. to be used in the ERB template
    variables(
      :memcached => deploy_config[:memcached] || {}
    )

    # only generate a file if there is Redis configuration
    not_if do
      deploy_config[:memcached].blank?
    end
  end
end