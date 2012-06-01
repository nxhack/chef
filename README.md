# Opscode chef : My Recipes

## bootstrap

* ubuntu10.04-apt-ec2
<pre>
Setup chef client using apt from opscode repository.
</pre>

## cookbooks

* ec2-hostname
<pre>
recipe           "ec2-hostname", "Set hostname and FQDN of the node."
recipe           "ec2-hostname::ec2_set_hosts", "Set init script - modify hosts file at boot time."
</pre>

* ec2-split-dns
<pre>
recipe           "ec2-split-dns", "Install bind9 and Setup dns zone files for Split DNS." 
recipe           "ec2-split-dns::ec2_set_dns_zone", "Install init script - modify dns zone files at boot time." 
recipe           "ec2-split-dns::ec2_set_resolver", "Setup dns resolver related files. : /etc/resolv.conf /etc/dhcp3/dhclient.conf
</pre>

* conf-tcpwrapper
<pre>
recipe           "conf-tcpwrapper", "Configure TCP Wrapper : Setup /etc/hosts.allow file."
</pre>
