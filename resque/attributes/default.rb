include_attribute "deploy"

default[:resque] = {}
default[:resque][:pool_size] = 4

case node[:platform_family]
when 'rhel', 'fedora', 'suse'
  default[:monit][:includes_dir] = '/etc/monit.d'
else
  default[:monit][:includes_dir] = '/etc/monit/conf.d'
end

node[:deploy].each do |application, deploy|
  
  default[:resque][application] = {}
  default[:resque][application][:pools] = {}
  
  # Default to node[:delayed_job][:pool_size] workers, each with empty ({}) config.
  default[:resque][application][:pools][:default] = Hash[node[:resque][:pool_size].times.map{|i| [i.to_s, {}] }]
  
  # Use node[:delayed_job][application][:pools][HOSTNAME] if provided.
  default[:resque][application][:pool] = node[:resque][application][:pools][node[:opsworks][:instance][:hostname]] || node[:resque][application][:pools][:default]
  Chef::Log.debug("Set resque attributes for #{application} to #{node[:resque][application].to_hash.inspect}")
  
  default[:resque][application][:restart_command] = "sudo monit restart -g resque_#{application}_group"
  
end