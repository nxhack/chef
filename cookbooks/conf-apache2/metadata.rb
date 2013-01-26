name             "conf-apache2"
maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Installs apache2-mpm-prefork"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "conf-apache2", "Installs apache2-mpm-prefork"

supports         "ubuntu"
