name             "ec2-get-my-region"
maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Store EC2 Region name to node attribute"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "ec2-get-my-region", "Store EC2 Region name to node attribute"

supports         "ubuntu"

attribute "ec2_region",
  :display_name => "EC2 Region name",
  :description => "Set my running ec2 region by ec2-get-my-region recipe"
