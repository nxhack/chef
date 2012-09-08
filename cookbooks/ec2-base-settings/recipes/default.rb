#
# Cookbook Name:: ec2-base-settings
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

    execute "conf_tzdata" do
      command "dpkg-reconfigure --frontend noninteractive tzdata"
      action :nothing
    end

    service "rsyslog" do
      action :nothing
    end

    service "cron" do
      action :nothing
    end

    execute "apt_update" do
      command "aptitude -y update"
      action :nothing
    end

    execute "apt_upgrade" do
      command "aptitude -y upgrade"
      action :nothing
    end

    template "/etc/timezone" do
      source "timezone.conf.erb"
      owner 'root'
      group 'root'
      mode "0644"
      variables({
         :set_tz => node['set_tz']
      })
      notifies :run, "execute[conf_tzdata]", :immediately
      notifies :restart, "service[rsyslog]", :immediately
      notifies :restart, "service[cron]", :immediately
      notifies :run, "execute[apt_update]", :immediately
      notifies :run, "execute[apt_upgrade]", :immediately
    end

    perl_ver = '5.10'
    if node['lsb']['codename'] == 'precise'
      perl_ver = '5.14'
    end
    package "libperl#{perl_ver}"

    package "sysstat"
    package "sqlite3"
    package "binutils"
    package "sharutils"
    package "traceroute"
    package "dump"
    package "s3cmd"
    package "git-core"
    package "make"

  end
end
