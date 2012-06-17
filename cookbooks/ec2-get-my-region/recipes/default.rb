#
# Cookbook Name:: ec2-get-my-region
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

if node[:cloud][:provider] == 'ec2'
  if node[:platform] == "ubuntu"

    ec2_region=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\\" '{print $4}'`.chomp

    ruby_block "get_my_region" do
      block do
        node.set[:ec2_region]=ec2_region
        node.save
      end
      action :nothing
    end

    template "/tmp/.chef-ec2-get-my-region.stat" do
      source ".chef-ec2-get-my-region.stat.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
        :ec2_region => ec2_region
      })
      notifies :create, "ruby_block[get_my_region]", :immediately
    end

  end
end
