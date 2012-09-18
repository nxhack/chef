#
# Cookbook Name:: conf-ssh-config
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

    directory "/home/ubuntu/.ssh" do
      owner "ubuntu"
      group "ubuntu"
      mode "0700"
    end

    cookbook_file "/home/ubuntu/.ssh/config" do
      source "config"
      owner "ubuntu"
      group "ubuntu"
      mode "0600"
    end

    execute "sshd_config_add_1" do
      command "echo 'UseDNS no' >> /etc/ssh/sshd_config"
      action :nothing
    end

    execute "sshd_config_add_2" do
      command "echo 'AddressFamily inet' >> /etc/ssh/sshd_config"
      action :nothing
    end

    file "#{Chef::Config[:file_cache_path]}/conf-ssh-config.done" do
      action :create_if_missing
      notifies :run, "execute[sshd_config_add_1]", :immediately
      notifies :run, "execute[sshd_config_add_2]", :immediately
    end

  end
end
