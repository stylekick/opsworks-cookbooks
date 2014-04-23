include_attribute 'deploy'

default[:tuxedo] = {}

node[:deploy].each do |application, deploy|
  default[:sidekiq][application.intern] = {}
  default[:sidekiq][application.intern][:restart_command] = "sudo monit restart -g tuxedo_#{application}_group"
  default[:sidekiq][application.intern][:syslog] = false
end

