name             "conf-MediaWiki"
maintainer       "Hirokazu MORIKAWA"
maintainer_email "morikawa@nxhack.com"
license          "Apache 2.0"
description      "Installs/Configures MediaWiki"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "conf-MediaWiki", "Installs/Configures MediaWiki"

supports         "ubuntu"
