Description
===========

Set up Split DNS for Amazon EC2. 
(This cookbook is simple version, only single node.)

Requirements
============

Attributes
==========

Usage
=====
<pre>
recipe           "ec2-split-dns", "Install bind9 and Setup dns zone files for Split DNS." 
recipe           "ec2-split-dns::ec2_set_dns_zone", "Install init script - modify dns zone files at boot time." 
recipe           "ec2-split-dns::ec2_set_resolver", "Setup dns resolver related files. : /etc/resolv.conf /etc/dhcp3/dhclie</pre>