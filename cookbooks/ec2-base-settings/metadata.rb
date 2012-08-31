maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Configures common settings & Installs common packages for EC2"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "ec2-base-settings", "Configures common settings & Installs common packages for EC2"

supports         "ubuntu"

attribute "set_tz",
  :display_name => "Set TimeZone",
  :description => "TimeZone to Set"
