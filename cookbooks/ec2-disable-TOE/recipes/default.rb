#
# Cookbook Name:: ec2-disable-TOE
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

    package "ethtool"

    if node['lsb']['codename'] == 'lucid'

      execute "update-network_interfaces-1" do
        command "echo 'post-up /usr/sbin/ethtool -K eth0 sg off' >> /etc/network/interfaces"
        action :nothing
      end

      execute "update-network_interfaces-2" do
        command "echo 'post-up /usr/sbin/ethtool -K eth0 tso off' >> /etc/network/interfaces"
        action :nothing
      end

      execute "sg_off" do
        command "/usr/sbin/ethtool -K eth0 sg off"
        action :nothing
      end

      execute "tso_off" do
        command "/usr/sbin/ethtool -K eth0 tso off"
        action :nothing
      end

      file "#{Chef::Config[:file_cache_path]}/ec2-disable-TOE.done" do
        action :create_if_missing
        notifies :run, "execute[update-network_interfaces-1]", :immediately
        notifies :run, "execute[update-network_interfaces-2]", :immediately
        notifies :run, "execute[sg_off]", :immediately
        notifies :run, "execute[tso_off]", :immediately
      end

    end

  end
end
