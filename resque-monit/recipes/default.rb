#
# Cookbook Name:: sidekiq
# Recipe:: default
#

node[:deploy].each do |application, deploy|
  template "#{node[:monit][:conf_dir]}/resque.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "monitrc.conf.erb"
    variables({
      :worker_count => node[:resque][:worker_count],
      :app_name => application,
      :deploy => deploy
    })
  end

  execute "ensure-resque-is-setup-with-monit" do
    command %Q{
      monit reload
    }
  end

  execute "restart-resque" do
    command %Q{
      echo "sleep 20 && monit -g resque restart all" | at now
    }
  end
end