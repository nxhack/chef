#
# Cookbook Name:: ubuntu-ruby-ng
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

if node['platform'] == 'ubuntu'

  ruby_block "setup_brightbox_ruby_ng" do
      block do
        `apt-add-repository ppa:brightbox/ruby-ng`
        `aptitude update`
        `aptitude -y install ruby rubygems ruby-switch`
        `aptitude -y install ruby1.9.3`
    end
    action :create
    not_if { ::File.exists?("/etc/apt/sources.list.d/brightbox-ruby-ng-lucid.list")}
  end

end
