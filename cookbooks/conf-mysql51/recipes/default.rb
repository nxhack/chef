# -*- coding: utf-8 -*-
#
# Cookbook Name:: conf-mysql51
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

    ruby_block "setup_mysql" do
      block do
        `echo mysql-server-5.1 mysql-server/root_password password #{node['mysql_root_pwd']} | debconf-set-selections`
        `echo mysql-server-5.1 mysql-server/root_password seen true | debconf-set-selections`
        `echo mysql-server-5.1 mysql-server/root_password_again password #{node['mysql_root_pwd']} | debconf-set-selections`
        `echo mysql-server-5.1 mysql-server/root_password_again seen true | debconf-set-selections`
        `echo mysql-server-5.1 mysql-server/start_on_boot boolean true | debconf-set-selections`
      end
      action :create
      not_if { ::File.exists?("/etc/mysql/my.cnf")}
    end

    package "mysql-server-5.1"

    # install metapackage !!
    package "mysql-server"

  end
end
