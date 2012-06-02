maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Configure TCP Wrapper : /etc/hosts.allow"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "conf-tcpwrapper", "Configure TCP Wrapper : Setup /etc/hosts.allow file."

%w{ ubuntu debian}.each do |os|
  supports os
end

attribute "ssh_allow_hosts",
  :display_name => "SSH : host : allow",
  :description => "Set array hostname or IP address to allow"
