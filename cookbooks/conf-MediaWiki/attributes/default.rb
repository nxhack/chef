#
default['mw']['version'] = '1.19'
default['mw']['patchlevel'] = '2'
#
default['mw']['db_name'] = 'mediawiki'
default['mw']['db_user'] = 'mediawiki'
#
# if unset ['mw']['db_password'] will be create automatically. 
## default['mw']['db_password'] = 'mw_db_password'
#
default['mw']['db_host'] = 'localhost'
default['mw']['table_prefix'] = 'mw_'

# for mw install.php
default['mw']['url'] = 'http://www.example.com/wiki'
default['mw']['title'] = 'TEST site'
default['mw']['admin_name'] = 'WikiSysop'
default['mw']['admin_password'] = 'MWAdmin0Pass'
