#
# Cookbook Name:: conf-php-mcrypt
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

    execute "fix_bad_comment" do
      command "sed --in-place 's|^#|;|g' /etc/php5/apache2/conf.d/mcrypt.ini"
      action :nothing
      ignore_failure true
    end

    service "apache2"

    file "#{Chef::Config[:file_cache_path]}/conf-php-mcrypt.done" do
      action :create_if_missing
      notifies :run, "execute[fix_bad_comment]", :immediately
      notifies :restart, "service[apache2]", :immediately
    end

  end
end
