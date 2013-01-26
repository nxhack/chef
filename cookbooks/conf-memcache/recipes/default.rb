#
# Cookbook Name:: conf-memcache
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

    package "memcached"
    service "memcached"

    package "php5-memcache"
    # package "python-memcache"
    # package "libcache-memcached-perl"

    cookbook_file "/etc/memcached.conf" do
      source "memcached.conf"
      owner "root"
      group "root"
      mode "0644"
      notifies :restart, "service[memcached]", :immediately
    end

    if node['lsb']['codename'] == 'lucid'
      # install php5-memcache manually, because package is too old.
      package "php5-dev"
      package "php-pear"
      package "re2c"

      execute "pecl_install_memcache" do
        command "pecl install memcache"
        action :nothing
        ignore_failure true
      end

      service "apache2"

      file "#{Chef::Config[:file_cache_path]}/conf-memcache.done" do
        action :create_if_missing
        notifies :run, "execute[pecl_install_memcache]", :immediately
        notifies :restart, "service[apache2]", :immediately
      end
    end

  end
end
