name             "conf-WordPress-cli"
maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Installs/Configures WordPress CLI tools and Plugins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "conf-WordPress-cli", "Installs/Configures WordPress CLI tools and Plugin"

supports         "ubuntu"
