#
#  NOTE: 'root_device' default value is "LABEL=cloudimg-rootfs" on Ubuntu System.
#
default['kernel_options'] = 'ipv6.disable=1'
# for Linux Kernel 2.x (for Ubuntu 10.04 LTS Lucid)
default['root_device_2'] = '/dev/sda1'
# for Linux Kernel 3.x (for Ubuntu 12.04 LTS Precise)
default['root_device_3'] = '/dev/xvda1'
