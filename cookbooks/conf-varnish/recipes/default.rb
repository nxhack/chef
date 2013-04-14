#
# Cookbook Name:: conf-varnish
# Recipe:: default
#
# Copyright 2012, Hirokazu MORIKAWA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['cloud']['provider'] == 'ec2'
  if node['platform'] == 'ubuntu'

    execute "varnish-apt-key" do
      command "curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -"
      action :nothing
    end

    execute "apt-update" do
      command "/usr/bin/aptitude update"
      action :nothing
    end

    template "/etc/apt/sources.list.d/varnish.list" do
      source "varnish.list.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
         :codename => 'lucid'
         ####  :codename => node['lsb']['codename']
      })
      notifies :run, "execute[varnish-apt-key]", :immediately
      notifies :run, "execute[apt-update]", :immediately
    end

    package "varnish"

    service "apache2" do
      action :nothing
    end

    service "varnish" do
      action :nothing
    end

    cookbook_file "/etc/varnish/my.vcl" do
      source "my.vcl"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/default/varnish" do
      source "varnish.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
         :varnish_port => node['varnish']['port'],
         :varnish_config => node['varnish']['config']
      })
    end

    # config apache2
    template "/etc/apache2/ports.conf" do
      source "ports.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
         :apache2_port => node['apache2']['port']
      })
      notifies :restart, "service[apache2]", :immediately
      notifies :restart, "service[varnish]", :immediately
    end

    # for logging
    package "libapache2-mod-rpaf"

    #cookbook_file "/etc/apache2/mods-available/rpaf.conf" do
    #  source "rpaf.conf"
    #  owner "root"
    #  group "root"
    #  mode "0644"
    #end

    #link "/etc/apache2/mods-enabled/rpaf.conf" do
    #  to "/etc/apache2/mods-available/rpaf.conf"
    #end

  end
end
