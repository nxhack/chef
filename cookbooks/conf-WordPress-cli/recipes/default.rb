# -*- coding: utf-8 -*-
#
# Cookbook Name:: conf-WordPress-cli
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

    package "git-core"
    package "php5-cli"

    distdir = 'var'
    if node['lsb']['codename'] == 'precise'
      distdir = 'srv'
    end

    # URL attribute is set node['wp']['url'], but at EC2 bootstrapping USE ec2.public_hostname or node['fqdn']:FIXME 
    execute "wp_core_install" do
      command "/usr/bin/wp core install --url='http://#{node['ec2']['public_hostname']}/blog' --title='#{node['wp']['title']}' --admin_email='#{node['wp']['admin_email']}' --admin_password='#{node['wp']['admin_password']}' --path='/#{distdir}/www/wordpress'"
      user "www-data"
      group "www-data"
      cwd "/#{distdir}/www/wordpress"
      ignore_failure true
      action :nothing
    end

    script "install_wp_cli" do
      interpreter "bash"
      user "root"
      cwd "/opt"
      code <<-EOH
      git clone --recursive git://github.com/wp-cli/wp-cli.git /opt/git/wp-cli
      cd /opt/git/wp-cli
      utils/dev-build
      EOH
      action :run
      ignore_failure true
      notifies :run, "execute[wp_core_install]", :immediately
      not_if { ::File.exists?("/usr/bin/wp")}
    end

    node['wp']['plugins'].each do |plugin|
      execute "activate_#{plugin}" do
        command "/usr/bin/wp plugin activate #{plugin}"
        user "www-data"
        group "www-data"
        cwd "/#{distdir}/www/wordpress"
        ignore_failure true
        action :nothing
      end
      execute "install_#{plugin}" do
        command "/usr/bin/wp plugin install #{plugin}"
        user "www-data"
        group "www-data"
        cwd "/#{distdir}/www/wordpress"
        ignore_failure true
        action :run
        notifies :run, "execute[activate_#{plugin}]", :immediately
        not_if { ::File.exists?("/#{distdir}/www/wordpress/wp-content/plugins/#{plugin}")}
      end
    end

    # for my custom setting
    execute "activate_akismet" do
      command "/usr/bin/wp plugin activate akismet"
      user "www-data"
      group "www-data"
      cwd "/#{distdir}/www/wordpress"
      ignore_failure true
      action :nothing
    end

    # for my custom setting
    execute "activate_wp-multibyte-patch" do
      command "/usr/bin/wp plugin activate wp-multibyte-patch"
      user "www-data"
      group "www-data"
      cwd "/#{distdir}/www/wordpress"
      ignore_failure true
      action :nothing
    end

    # for APC Object Cache
    execute "setup_apc" do
      command "/bin/mv /#{distdir}/www/wordpress/wp-content/plugins/apc/object-cache.php /#{distdir}/www/wordpress/wp-content/"
      user "www-data"
      group "www-data"
      cwd "/#{distdir}/www/wordpress"
      ignore_failure true
      action :run
      notifies :run, "execute[activate_akismet]", :immediately
      notifies :run, "execute[activate_wp-multibyte-patch]", :immediately
      not_if { ::File.exists?("/#{distdir}/www/wordpress/wp-content/object-cache.php")}
    end

  end
end
