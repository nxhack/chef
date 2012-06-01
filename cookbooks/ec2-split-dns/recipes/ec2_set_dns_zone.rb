#
# Cookbook Name:: ec2-split-dns
# Recipe:: ec2-split-dns::ec2_set_dns_zone
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

if node[:cloud][:provider] == 'ec2'
  if ['debian','ubuntu'].member? node[:platform]

    package "python-ipy"

    directory "/usr/local/etc/init" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end

    cookbook_file "/usr/local/etc/init/ec2-set-dns-zone" do
      source "ec2-set-dns-zone"
      owner "root"
      group "root"
      mode "0755"
    end

    directory "/usr/local/etc/bind/templates" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end

    cookbook_file "/usr/local/etc/bind/templates/arpa.tmpl" do
      source "arpa.tmpl"
      owner "root"
      group "root"
      mode "0644"
    end

    cookbook_file "/usr/local/etc/bind/templates/conf.tmpl" do
      source "conf.tmpl"
      owner "root"
      group "root"
      mode "0644"
    end

    cookbook_file "/usr/local/etc/bind/templates/zone.tmpl" do
      source "zone.tmpl"
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

    cookbook_file "/etc/bind/named.conf.options" do
      source "named.conf.options"
      owner "root"
      group "root"
      mode "0644"
    end

    link "/etc/rc2.d/S13ec2-set-dns-zone" do
      to "/usr/local/etc/init/ec2-set-dns-zone"
    end

  end
end
