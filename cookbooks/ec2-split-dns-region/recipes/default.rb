#
# Cookbook Name:: ec2-split-dns-region
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

require "ipaddr"

if node['cloud']['provider'] == 'ec2'
  if ['debian','ubuntu'].member? node['platform']

    package "bind9"

    service "bind9" do
      supports :status => true, :reload => true, :restart => true
      action [ :enable, :start ]
    end

    if Chef::Config[:solo]
      Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
    else

      ec2_region = `curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\\" '{print $4}'`.chomp

      ruby_block "set_my_region" do
        block do
          node.set['ec2_region'] = ec2_region
          node.save
        end
        action :nothing
      end

      execute "update_resolvconf" do
        command "/sbin/resolvconf -u"
        action :nothing
        only_if { node['lsb']['codename'] == 'precise' }
      end

      my_servers = search(:node,"ec2_region:#{ec2_region}")

      my_servers.each do |server|
        if server['fqdn'] != node['fqdn'] 
          server.set['ec2_arpa'] = IPAddr.new(server['ipaddress']).reverse

          template "/etc/bind/db.#{server['fqdn']}.arpa" do
            source "db.otherarpa.erb"
            owner "root"
            group "root"
            mode "0644"
            variables({
              :fqdn => server['fqdn']
            })
          end

          template "/etc/bind/db.#{server['fqdn']}.zone" do
            source "db.otherzone.erb"
            owner "root"
            group "root"
            mode "0644"
            variables({
              :ipaddress => server['ipaddress']
            })
          end
        end
      end

      cookbook_file "/etc/default/bind9" do
        source "bind9"
        owner "root"
        group "root"
        mode "0644"
      end

      cookbook_file "/etc/bind/named.conf.options" do
        source "named.conf.options"
        owner "root"
        group "root"
        mode "0644"
      end

      cookbook_file "/etc/bind/named.conf.local" do
        source "named.conf.local"
        owner "root"
        group "root"
        mode "0644"
      end

      template "/etc/bind/db.myarpa" do
        source "db.myarpa.erb"
        owner "root"
        group "root"
        mode "0644"
        variables({
          :fqdn => node['fqdn']
        })
      end

      template "/etc/bind/db.myzone" do
        source "db.myzone.erb"
        owner "root"
        group "root"
        mode "0644"
        variables({
          :ipaddress => node['ipaddress']
        })
      end

      arpa = IPAddr.new(node['ipaddress']).reverse
      template "/etc/bind/myzone.conf" do
        source "myzone.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        variables({
          :arpa => arpa,
          :my_servers => my_servers,
          :fqdn => node['fqdn']
        })
        notifies :restart, "service[bind9]", :immediately
        notifies :create, "ruby_block[set_my_region]", :immediately
        notifies :run, "execute[update_resolvconf]", :immediately
      end
    end

  end
end
