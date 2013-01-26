name             "ec2-hostname"
maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "MIT"
description      "Configures hostname and FQDN on Amazon Web Services"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.4"
recipe           "ec2-hostname", "Set hostname and FQDN of the node."
recipe           "ec2-hostname::ec2_set_hosts", "Install init script - modify hosts file at boot time."

%w{ ubuntu debian}.each do |os|
  supports os
end

attribute "set_fqdn",
  :display_name => "Set FQDN",
  :description => "FQDN to Set"
