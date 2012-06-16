# Opscode chef : My Recipes

## bootstrap

* [https://github.com/nxhack/chef/blob/master/bootstrap/ubuntu10.04-apt-ec2.erb ubuntu10.04-apt-ec2]
<pre>
Setup chef client using apt from opscode repository.
</pre>

## cookbooks

* [https://github.com/nxhack/chef/tree/master/cookbooks/ec2-hostname ec2-hostname]
<pre>
recipe           "ec2-hostname", "Set hostname and FQDN of the node."
recipe           "ec2-hostname::ec2_set_hosts", "Install init script - modify hosts file at boot time."
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/ec2-split-dns ec2-split-dns]
<pre>
recipe           "ec2-split-dns", "Install bind9 and Setup dns zone files for Split DNS." 
recipe           "ec2-split-dns::ec2_set_dns_zone", "Install init script - modify dns zone files at boot time." 
recipe           "ec2-split-dns::ec2_set_resolver", "Setup dns resolver related files. : /etc/resolv.conf /etc/dhcp3/dhclient.conf"
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/ec2-lucid-backports ec2-lucid-backports]
<pre>
recipe           "ec2-lucid-backports", "Configure ec2 lucid backports repository"
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/ec2-grub-menu-lst ec2-grub-menu-lst]
<pre>
recipe           "ec2-grub-menu-lst", "Configures grub : setup kernel options"
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/conf-bashrc conf-bashrc]
<pre>
recipe           "conf-bashrc", "Configure bashrc : Setup for ubuntu account."
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/conf-emacs-skk conf-emacs-skk]
<pre>
recipe           "conf-emacs-skk", "Configure emacs & skk : Setup for ubuntu account."
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/conf-screen conf-screen]
<pre>
recipe           "conf-screen", "Configure screen : Setup for ubuntu account."
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/conf-sysctl conf-sysctl]
<pre>
recipe           "conf-sysctl", "Configure sysctl"
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/conf-limits conf-limits]
<pre>
recipe           "conf-limits", "Install my limits"
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/conf-tcpwrapper conf-tcpwrapper]
<pre>
recipe           "conf-tcpwrapper", "Configure TCP Wrapper : Setup /etc/hosts.allow file."
</pre>

* [https://github.com/nxhack/chef/tree/master/cookbooks/conf-tmux conf-tmux]
<pre>
recipe           "conf-tmux", "Configure tmux : Setup for ubuntu account."
</pre>
