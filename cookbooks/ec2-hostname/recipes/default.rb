#
# Cookbook Name:: ec2-hostname
# Recipe:: default
#
# Copyright 2012, Hirokazu MORIKAWA
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

if node[:cloud][:provider] == 'ec2'
  if ['debian','ubuntu'].member? node[:platform]
    fqdn = node[:set_fqdn]
    if fqdn
      fqdn =~ /^([^.]+)/
      hostname = $1
      changed = false

      if node[:hostname] != hostname
        file '/etc/hostname' do
          content "#{hostname}"
          mode "0644"
        end
        execute "hostname -F /etc/hostname"
        changed=true
      end

      if node[:fqdn] != fqdn
        template "/etc/hosts" do
          source "hosts.erb"
          owner "root"
          group "root"
          mode "0644"
          variables({
            :ipaddress => node[:ipaddress],
            :fqdn => fqdn,
            :hostname => hostname
          })
        end
        changed = true
      end

      # /etc/hosts is correct format (kernel hostname & hosts file)
      # So /bin/hostname -i is work
      ipaddress=`/bin/hostname -i`.chomp
      if node[:ipaddress] != ipaddress
        template "/etc/hosts" do
          source "hosts.erb"
          owner "root"
          group "root"
          mode "0644"
          variables({
            :ipaddress => node[:ipaddress],
            :fqdn => fqdn,
            :hostname => hostname
          })
        end
        changed = true
      end

      ohai "reload" if changed
    else
      log "Please set the set_fqdn attribute to desired hostname" do
        level :warn
      end
    end
  end
end

