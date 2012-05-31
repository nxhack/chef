# Opscode chef files

## bootstrap

## cookbooks

* ec2-hostname
<pre>
   recipe           "ec2-hostname", "Set hostname and FQDN of the node."
   recipe           "ec2-hostname::ec2_set_hosts", "Set init script for modify hosts file"
</pre>
