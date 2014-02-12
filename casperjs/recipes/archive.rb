include_recipe "phantomjs"


%w(unzip).each do |package|
  package package
end


basename = node['casperjs']['version']


remote_file "/usr/local/src/casperjs-#{basename}" do
  action :create_if_missing
  backup false
  mode '0644'
  source "https://github.com/n1k0/casperjs/archive/#{basename}.zip"
end


execute 'Install casperjs' do
  command "unzip /usr/local/src/casperjs-#{basename} -d /usr/local/"
  not_if "test -d /usr/local/casperjs-#{basename}"
end

link '/usr/local/bin/casperjs' do
  to "/usr/local/casperjs-#{basename}/rubybin/casperjs"
end