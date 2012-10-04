#
# Cookbook Name:: ec2-split-dns-region
# Recipe:: ec2-split-dns-region::ec2_set_resolver
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
  if ['debian','ubuntu'].member? node['platform']

    dhclientconf = '/etc/dhcp3/dhclient.conf'
    resolvconf = '/etc/resolv.conf'
    if node['lsb']['codename'] == 'precise'
      dhclientconf = '/etc/dhcp/dhclient.conf'
      resolvconf = '/etc/resolvconf/resolv.conf.d/base'
    end

    template dhclientconf do
      source "dhclient.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
        :domain => node['domain']
      })
    end

    execute "update_resolvconf" do
      command "/sbin/resolvconf -u"
      action :nothing
      only_if { node['lsb']['codename'] == 'precise' }
    end

    template resolvconf do
      source "resolv.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
        :domain => node['domain']
      })
      notifies :run, "execute[update_resolvconf]", :immediately
    end

  end
end
