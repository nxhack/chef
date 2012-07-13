# -*- coding: utf-8 -*-
#
# Cookbook Name:: conf-WordPress-JP
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

    ruby_block "force_setup_wordpress" do
      block do
        `aptitude -y install wordpress`
        `a2enmod rewrite`
        `/etc/init.d/apache2 stop`
        `/bin/bash /usr/share/doc/wordpress/examples/setup-mysql -n wordpress localhost`
        `mv /etc/wordpress /etc/wordpress-jp`
        `mv /usr/share/doc/wordpress /etc/wordpress-jp/doc`
        `apt-get -y remove wordpress`
        `aptitude keep-all`
        `aptitude -y purge wordpress`
        `rm /var/www/localhost`
        `rm -rf /var/www/wp-uploads`
        `cat /etc/wordpress-jp/config-localhost.php | fgrep -v '/localhost' > /etc/wordpress-jp/config-jp.php`
        `chmod 640 /etc/wordpress-jp/config-jp.php`
        `chgrp www-data /etc/wordpress-jp/config-jp.php`
        `mv /etc/wordpress-jp/wp-config.php /etc/wordpress-jp/wp-config.php.deb-orig`
      end
      action :create
      not_if { ::File.exists?("/etc/wordpress-jp/wp-config.php")}
    end

    cookbook_file "/etc/wordpress-jp/wp-config.php" do
      source "wp-config.php"
      owner "root"
      group "root"
      mode "0644"
    end

    cookbook_file "/etc/wordpress-jp/apache2.conf" do
      source "apache2.conf"
      owner "root"
      group "root"
      mode "0644"
    end

    ruby_block "force_install_wordpress_jp" do
      block do
        `wget -qO - http://ja.wordpress.org/latest-ja.tar.gz > #{Chef::Config[:file_cache_path]}/wordpress-latest-ja.tar.gz`
        `tar xfz #{Chef::Config[:file_cache_path]}/wordpress-latest-ja.tar.gz -C /var/www`
        `mv /var/www/wordpress /var/www/blog`
        `chown -R www-data:www-data /var/www/blog`
      end
      action :create
      not_if { ::File.exists?("/etc/apache2/conf.d/wordpress.conf")}
    end

    link "/var/www/blog/wp-config.php" do
      to "/etc/wordpress-jp/wp-config.php"
    end

    link "/etc/apache2/conf.d/wordpress.conf" do
      to "/etc/wordpress-jp/apache2.conf"
      notifies :start, "service[apache2]", :immediately
    end

  end
end
