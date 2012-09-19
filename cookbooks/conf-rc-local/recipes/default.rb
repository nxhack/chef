#
# Cookbook Name:: conf-rc.local
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

    execute "modify_rc_local_01" do
      command "sed --in-place 's|^[^#]*exit 0|/sbin/ifconfig eth0 txqueuelen 10000\\n&|' /etc/rc.local"
      action :nothing
    end

    if node['os_version'] =~ /^3\./
      rc_root_device = 'xvda1'
    else
      rc_root_device = 'sda1'
    end
    execute "modify_rc_local_02" do
      command "sed --in-place 's|^[^#]*exit 0|/sbin/e2label /dev/#{rc_root_device} cloudimg-rootfs\\n&|' /etc/rc.local"
      action :nothing
    end
    execute "modify_rc_local_03" do
      command "sed --in-place 's|^[^#]*exit 0|echo 512 > /sys/block/#{rc_root_device}/queue/nr_requests\\n&|' /etc/rc.local"
      action :nothing
    end
    execute "modify_rc_local_04" do
      command "sed --in-place 's|^[^#]*exit 0|echo \'noop\' > /sys/block/#{rc_root_device}/queue/scheduler\\n&|' /etc/rc.local"
      action :nothing
    end

    file "#{Chef::Config[:file_cache_path]}/conf-rc-local.done" do
      action :create_if_missing
      notifies :run, "execute[modify_rc_local_01]", :immediately
      notifies :run, "execute[modify_rc_local_02]", :immediately
      notifies :run, "execute[modify_rc_local_03]", :immediately
      notifies :run, "execute[modify_rc_local_04]", :immediately
    end

  end
end
