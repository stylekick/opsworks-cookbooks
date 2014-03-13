#
# Cookbook Name:: sidekiq
# Recipe:: restart
#

node[:deploy].each do |application, deploy|
  execute "restart-resque" do
    command %Q{
      monit -g resque restart all
    }
  end
end