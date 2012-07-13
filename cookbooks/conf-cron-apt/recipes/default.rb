#
# Cookbook Name:: conf-cron-apt
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

    package "cron-apt"

    cookbook_file "/etc/cron-apt/action.d/3-download" do
      source "3-download"
      owner "root"
      group "root"
      mode "0644"
    end

    cookbook_file "/etc/cron-apt/action.d/5-upgrade" do
      source "5-upgrade"
      owner "root"
      group "root"
      mode "0644"
    end

    template "/etc/cron-apt/config" do
      source "config.erb"
      owner "root"
      group "root"
      mode "0644"
    end

  end
end
