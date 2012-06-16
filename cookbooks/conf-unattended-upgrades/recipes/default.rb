#
# Cookbook Name:: conf-unattended-upgrades
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

    cookbook_file "/etc/apt/apt.conf.d/10periodic" do
      source "10periodic"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/apt/apt.conf.d/50unattended-upgrades" do
      source "50unattended-upgrades.erb"
      owner "root"
      group "root"
      mode "0644"
    end

  end
end
