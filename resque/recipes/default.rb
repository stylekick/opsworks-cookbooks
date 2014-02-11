# template File.join(node[:monit][:conf_dir], "resque.monitrc") do
#   source "resque.monitrc.erb"
#   mode 0644
#   #TODO: This should only happen if the service is running, after rebooting
# #  notifies :restart, resources(:service => "monit")
# end

node[:deploy].each do |application, deploy|
  worker_id = 1
  
  Chef::Log.debug("Starting resque workers")
  
  3.times do
    pid = "#{deploy[:deploy_to]}/tmp/pids/resque_work_#{worker_id}.pid"
    command "bundle exec rake resque:work RAILS_ENV=production QUEUE=* PIDFILE=#{pid} BACKGROUND=yes VERBOSE=1"
    worker_id += 1
  end
end