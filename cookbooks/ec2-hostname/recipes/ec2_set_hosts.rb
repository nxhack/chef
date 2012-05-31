#
# Cookbook Name:: ec2-hostname
# Recipe:: ec2-set-hosts
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

    directory "/usr/local/etc/init" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end

    cookbook_file "/usr/local/etc/init/ec2-set-hosts" do
      source "ec2-set-hosts"
      mode 0755
      owner "root"
      group "root"
    end

    directory "/usr/local/etc/bind/templates" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end

    cookbook_file "/usr/local/etc/bind/templates/hosts.tmpl" do
      source "hosts.tmpl"
      mode 0644
      owner "root"
      group "root"
    end

    link "/etc/rc2.d/S12ec2-set-hosts" do
      to "/usr/local/etc/init/ec2-set-hosts"
    end

  end
end
