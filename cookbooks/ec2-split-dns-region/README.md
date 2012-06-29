Description
===========

Set up Split DNS for Amazon EC2. 

Requirements
============

Attributes
==========

Usage
=====
<pre>
recipe           "ec2-split-dns-region", "Install bind9 and Setup dns zone files for Split DNS." 
recipe           "ec2-split-dns-region::ec2_set_resolver", "Setup dns resolver related files. : /etc/resolv.conf /etc/dhcp3/dhclient.conf"
</pre>