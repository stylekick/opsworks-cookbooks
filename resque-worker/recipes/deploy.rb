include_recipe 'deploy' #use builtin deploy::default recipe

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do #use built-in definition to setup the directory structure
    #set variables to pass into the deploy_dir definition
    user deploy[:user] 
    group deploy[:group]
    path deploy[:deploy_to]
  end
  
  opsworks_rails do
    deploy_data deploy
    app application
  end
  
  opsworks_deploy do 
    #use built-in definition to check out the app's code from the repo
    #deploy and application come from the deployment JSON
    deploy_data deploy 
    app application
  end
end