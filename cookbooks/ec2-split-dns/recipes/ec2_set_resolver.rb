#
# Cookbook Name:: ec2-split-dns
# Recipe:: ec2-split-dns::ec2_set_resolver
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

    template "/etc/dhcp3/dhclient.conf" do
      source "dhclient.conf.erb"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/resolv.conf" do
      source "resolv.conf.erb"
      owner "root"
      group "root"
      mode "0644"
    end

  end
end
