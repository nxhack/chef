# Please set array carefully!
#  NOTE: 'root_device' default value is "LABEL=cloudimg-rootfs" on Ubuntu System.
#
default['kernel_options'] = "acpi=off ipv6.disable=1"
default['root_device'] = "/dev/sda1"
default['grub_menu_lst_flg'] = "DONE"
