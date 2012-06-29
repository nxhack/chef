maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Setup Split DNS for Amazon EC2 (same region nodes)"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "ec2-split-dns-region", "Install bind9 and Setup dns zone files for Split DNS." 
recipe           "ec2-split-dns-region::ec2_set_resolver", "Setup dns resolver related files. : /etc/resolv.conf /etc/dhcp3/dhclient.conf" 

%w{ ubuntu debian}.each do |os|
  supports os
end
