# Adapted from nginx::stop: https://github.com/aws/opsworks-cookbooks/blob/master/nginx/recipes/stop.rb

# include_recipe "resque::service"

node[:deploy].each do |application, deploy|
  
  execute "stop resque workers for Rails app #{application}" do
    files.split("\n").each do |pid|
      command "kill -s QUIT `cat #{pid}` && rm #{pid}"
    end
  end
  
end