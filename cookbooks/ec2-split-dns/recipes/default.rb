#
# Cookbook Name:: ec2-split-dns
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

if node[:cloud][:provider] == 'ec2'
  if ['debian','ubuntu'].member? node[:platform]

    package "bind9"

    service "bind9" do
      supports :status => true, :reload => true, :restart => true
      action [ :enable, :start ]
    end

    cookbook_file "/etc/default/bind9" do
      source "bind9"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/bind/named.conf.options" do
      source "named.conf.options.erb"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/bind/named.conf.local" do
      source "named.conf.local.erb"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/bind/db.myarpa" do
      source "db.myarpa.erb"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/bind/db.myzone" do
      source "db.myzone.erb"
      owner "root"
      group "root"
      mode "0644"
    end

    arpa = IPAddr.new(node[:ipaddress]).reverse
    template "/etc/bind/myzone.conf" do
      source "myzone.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
        :arpa => arpa
      })
      notifies :restart, "service[bind9]"
    end

  end
end
