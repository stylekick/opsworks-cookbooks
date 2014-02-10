# Adapted from nginx::stop: https://github.com/aws/opsworks-cookbooks/blob/master/nginx/recipes/stop.rb

include_recipe "resque::service"

node[:deploy].each do |application, deploy|
  
  execute "stop Rails app #{application}" do
    command "sudo monit stop -g resque_#{application}_group"
  end
  
end