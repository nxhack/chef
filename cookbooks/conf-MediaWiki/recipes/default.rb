# -*- coding: utf-8 -*-
#
# Cookbook Name:: conf-MediaWiki
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

    package "libgd2-xpm"
    package "libgd2-xpm-dev"
    package "php5-gd"

    db_name = node['mw']['db_name']
    db_user = node['mw']['db_user']
    node.set_unless['mw']['db_password'] = secure_password
    db_password = node['mw']['db_password']
    db_host = node['mw']['db_host']
    table_prefix = node['mw']['table_prefix']

    # URL attribute is set node['mw']['url'], but at EC2 bootstrapping USE ec2.public_hostname or node['fqdn']:FIXME 
    execute "mw_core_install" do
      command "/usr/bin/php install.php --server 'http://#{node['ec2']['public_hostname']}' --dbname '#{db_name}' --dbuser '#{db_user}' --dbpass '#{db_password}' --dbprefix '#{table_prefix}' --dbserver '#{db_host}' --lang 'ja' --pass '#{node['mw']['admin_password']}' --scriptpath '/wiki' '#{node['mw']['title']}' '#{node['mw']['admin_name']}'"
      user "www-data"
      group "www-data"
      cwd "/#{distdir}/www/mediawiki/maintenance"
      ignore_failure true
      action :nothing
    end

    # create database for MediaWiki
    bash "mw_create_database" do
      user "root"
      cwd "/tmp"
      flags "-e"
      code <<-EOH
mysql --defaults-extra-file=/etc/mysql/debian.cnf <<EOF
CREATE DATABASE #{db_name};
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX
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

    # mkdir '/#{distdir}/www/mediawiki'
    directory "/#{distdir}/www/mediawiki" do
      owner "www-data"
      group "www-data"
      mode "0750"
      action :create
    end

    # mkdir '/etc/mediawiki-chef'
    directory "/etc/mediawiki-chef" do
      owner "root"
      group "root"
      mode "0755"
      action :create
    end

    template "/etc/mediawiki-chef/apache.conf" do
      source "apache.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
         :distdir => distdir
      })
    end

    ruby_block "install_mediawiki_package" do
      block do
        `wget -qO - http://download.wikimedia.org/mediawiki/#{node['mw']['version']}/mediawiki-#{node['mw']['version']}.#{node['mw']['patchlevel']}.tar.gz > #{Chef::Config[:file_cache_path]}/mediawiki.tar.gz`
        `tar xfz #{Chef::Config[:file_cache_path]}/mediawiki.tar.gz -C /#{distdir}/www/mediawiki --strip-components=1`
        `chown -R www-data:www-data /#{distdir}/www/mediawiki`
      end
      action :create
      not_if { ::File.exists?("/etc/apache2/conf.d/mediawiki.conf")}
    end

    execute "chmod_LocalSettings" do
      command "chmod o-rwx /#{distdir}/www/mediawiki/LocalSettings.php"
      action :nothing
    end

    link "/etc/apache2/conf.d/mediawiki.conf" do
      to "/etc/mediawiki-chef/apache.conf"
      notifies :run, "bash[mw_create_database]", :immediately
      notifies :run, "execute[mw_core_install]", :immediately
      notifies :run, "execute[chmod_LocalSettings]", :immediately
      notifies :restart, "service[apache2]", :immediately
    end

  end
end
