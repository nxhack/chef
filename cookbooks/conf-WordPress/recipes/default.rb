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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

if node['cloud']['provider'] == 'ec2'
  if node['platform'] == 'ubuntu'

    distdir = 'var'
    if node['lsb']['codename'] == 'precise'
      distdir = 'srv'
    end

    service "apache2"

    package "php5-gd"
    # package "tinymce"
    # package "javascript-common"
    # package "libjs-cropper"
    # package "libjs-prototype"
    # package "libjs-scriptaculous"

    db_name = node['wp']['db_name']
    db_user = node['wp']['db_user']
    node.set_unless['wp']['db_password'] = secure_password
    db_password = node['wp']['db_password']
    db_host = node['wp']['db_host']
    table_prefix = node['wp']['table_prefix']

    auth_key = secure_password + secure_password + secure_password + secure_password
    secre_auth_key = secure_password + secure_password + secure_password + secure_password
    logged_in_key = secure_password + secure_password + secure_password + secure_password
    nonce_key = secure_password + secure_password + secure_password + secure_password
    auth_salt = secure_password + secure_password + secure_password + secure_password
    secre_auth_salt = secure_password + secure_password + secure_password + secure_password
    logged_in_salt = secure_password + secure_password + secure_password + secure_password
    nonce_salt = secure_password + secure_password + secure_password + secure_password

    # create database for WordPress
    bash "create_database" do
      user "root"
      cwd "/tmp"
      flags "-e"
      code <<-EOH
mysql --defaults-extra-file=/etc/mysql/debian.cnf <<EOF
CREATE DATABASE #{db_name};
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
ON #{db_name}.*
TO #{db_name}@localhost
IDENTIFIED BY '#{db_password}';
FLUSH PRIVILEGES;
EOF
      EOH
      action :nothing
      only_if { db_host == 'localhost' }
    end

    # mkdir '/#{distdir}/www'
    directory "/#{distdir}/www" do
      owner "root"
      group "www-data"
      mode "0750"
      recursive true
      action :create
    end

    # mkdir '/#{distdir}/www/wordpress'
    directory "/#{distdir}/www/wordpress" do
      owner "root"
      group "www-data"
      mode "0750"
      action :create
    end

    # mkdir '/etc/wordpress-chef'
    directory "/etc/wordpress-chef" do
      owner "root"
      group "root"
      mode "0755"
      action :create
    end

    template "/etc/wordpress-chef/config-chef.php" do
      source "config-chef.php.erb"
      owner "root"
      group "www-data"
      mode "0640"
      variables({
         :db_name => db_name,
         :db_user => db_user,
         :db_password => db_password,
         :db_host => db_host,
         :auth_key => auth_key,
         :secre_auth_key => secre_auth_key,
         :logged_in_key => logged_in_key,
         :nonce_key => nonce_key,
         :auth_salt => auth_salt,
         :secre_auth_salt => secre_auth_salt,
         :logged_in_salt => logged_in_salt,
         :nonce_salt => nonce_salt,
         :table_prefix => table_prefix
      })
    end

    template "/etc/wordpress-chef/wp-config.php" do
      source "wp-config.php.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
         :distdir => distdir
      })
    end

    template "/etc/wordpress-chef/apache2.conf" do
      source "apache2.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
         :distdir => distdir
      })
    end

    ruby_block "install_wordpress_jp_package" do
      block do
        `wget -qO - http://ja.wordpress.org/latest-ja.tar.gz > #{Chef::Config[:file_cache_path]}/wordpress-latest-ja.tar.gz`
        `tar xfz #{Chef::Config[:file_cache_path]}/wordpress-latest-ja.tar.gz -C /#{distdir}/www/wordpress --strip-components=1`
        `chown -R www-data:www-data /#{distdir}/www/wordpress`
      end
      action :create
      not_if { ::File.exists?("/etc/apache2/conf.d/wordpress.conf")}
    end

    ruby_block "install_additional_modules" do
      block do
        `a2enmod rewrite`
      end
      action :nothing
    end

    link "/#{distdir}/www/wordpress/wp-config.php" do
      to "/etc/wordpress-chef/wp-config.php"
    end

    link "/etc/apache2/conf.d/wordpress.conf" do
      to "/etc/wordpress-chef/apache2.conf"
      notifies :run, "bash[create_database]", :immediately
      notifies :create, "ruby_block[install_additional_modules]", :immediately
      notifies :restart, "service[apache2]", :immediately
    end

  end
end
