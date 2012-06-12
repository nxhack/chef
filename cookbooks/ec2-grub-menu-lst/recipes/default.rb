#
# Cookbook Name:: ec2-grub-menu-lst
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

if node[:cloud][:provider] == 'ec2'
  if node[:platform] == "ubuntu"

    execute "update-grub-menu-list-1" do
      command "sed --in-place 's|^# kopt=root=LABEL=cloudimg-rootfs ro|# kopt=root=#{node['root_device']} ro|' /boot/grub/menu.lst"
      action :nothing
    end

    execute "update-grub-menu-list-2" do
      command "sed --in-place 's|^# defoptions=xencons=hvc0 console=hvc0|# defoptions=xencons=hvc0 console=hvc0 #{node['kernel_options']}|' /boot/grub/menu.lst"
      action :nothing
    end

    execute "update-grub-legacy-ec2" do
      command "/usr/sbin/update-grub-legacy-ec2"
      action :nothing
    end

    template "/boot/grub/chef-menu.lst.dummy" do
      source "chef-menu.lst.dummy.erb"
      action :create_if_missing
      notifies :run, resources(:execute => "update-grub-menu-list-1"), :immediately
      notifies :run, resources(:execute => "update-grub-menu-list-2"), :immediately
      notifies :run, resources(:execute => "update-grub-legacy-ec2"), :immediately
    end

  end
end
