# Opscode chef files

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
