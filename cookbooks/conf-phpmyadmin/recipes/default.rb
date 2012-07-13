# -*- coding: utf-8 -*-
#
# Cookbook Name:: conf-phpmyadmin
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

    service "apache2"

    ruby_block "pre_setup_phpmyadmin" do
      block do
        `echo phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2 | debconf-set-selections`
        `echo phpmyadmin phpmyadmin/reconfigure-webserver seen true | debconf-set-selections`
        `echo phpmyadmin phpmyadmin/dbconfig-install boolean true | debconf-set-selections`
        `echo phpmyadmin phpmyadmin/dbconfig-install seen true | debconf-set-selections`
        `echo phpmyadmin phpmyadmin/mysql/admin-pass password #{node['mysql_root_pwd']} | debconf-set-selections`
        `echo phpmyadmin phpmyadmin/mysql/app-pass password #{node['phpmyadmin_pwd']} | debconf-set-selections`
        `echo phpmyadmin phpmyadmin/app-password-confirm password #{node['phpmyadmin_pwd']} | debconf-set-selections`
      end
      action :create
      not_if { ::File.exists?("/etc/phpmyadmin/config.inc.php")}
    end

    package "phpmyadmin"

    cookbook_file "/etc/phpmyadmin/apache2-auth.conf" do
      source "apache2-auth.conf"
      owner "root"
      group "root"
      mode "0644"
    end

    ruby_block "post_setup_phpmyadmin" do
      block do
        `cp /etc/phpmyadmin/htpasswd.setup /etc/phpmyadmin/htpasswd.admin`
        `chgrp www-data /etc/phpmyadmin/htpasswd.admin`
      end
      action :create
      not_if { ::File.exists?("/etc/apache2/conf.d/phpmyadmin-auth.conf")}
    end

    link "/etc/apache2/conf.d/phpmyadmin-auth.conf" do
      to "/etc/phpmyadmin/apache2-auth.conf"
      notifies :restart, "service[apache2]", :immediately
    end

  end
end
