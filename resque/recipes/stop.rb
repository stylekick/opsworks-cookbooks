# Adapted from nginx::stop: https://github.com/aws/opsworks-cookbooks/blob/master/nginx/recipes/stop.rb

# include_recipe "resque::service"

node[:deploy].each do |application, deploy|
  
  files = `cd #{deploy[:deploy_to]}; ls -1 tmp/pids/resque_work*.pid`
  files.split("\n").each do |pid|
    
    execute "stop resque worker #{pid} for Rails app #{application}" do
      command "kill -s QUIT `cat #{pid}` && rm #{pid}"
    end
  end
  
end