maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Configures cron-apt"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "conf-cron-apt", "Configure cron-apt"

supports         "ubuntu"

attribute "mailaddress_of_sysadmin",
  :display_name => "eMail of SysAdmin",
  :description => "Set email address to receive action log"
