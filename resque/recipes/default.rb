template File.join(node[:monit][:conf_dir], "resque.monitrc") do
  source "resque.monitrc.erb"
  mode 0644
  #TODO: This should only happen if the service is running, after rebooting
#  notifies :restart, resources(:service => "monit")
end