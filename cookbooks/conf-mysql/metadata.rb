name             "conf-mysql"
maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Installs/Configures MySQL"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "conf-mysql", "Installs/Configures MySQL"

supports         "ubuntu"
