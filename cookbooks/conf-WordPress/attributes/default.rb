#
default['wp']['db_name'] = 'wordpress'
default['wp']['db_user'] = 'wordpress'
#
# if unset ['wp']['db_password'] will be create automatically. 
## default['wp']['db_password'] = 'wp_db_password'
#
default['wp']['db_host'] = 'localhost'
default['wp']['table_prefix'] = 'wp_'

# wp-cli
default['wp']['url'] = 'http://www.example.com/blog'
default['wp']['title'] = 'TEST site'
default['wp']['admin_email'] = 'admin@example.com'
default['wp']['admin_password'] = 'WPAdmin0Pass'
#
default['wp']['plugins'] = [ 'apc', '001-prime-strategy-translate-accelerator', 'backwpup', 'db-cache-reloaded-fix', 'easy-fancybox', 'pushpress', 'syntaxhighlighter', 'tinymce-advanced', 'wp-crontrol', 'wp-page-numbers', 'wp-social-bookmarking-light', 'wptouch' ]
#
# not used
default['wp']['activate'] = [ 'akismet', 'wp-multibyte-patch', '001-prime-strategy-translate-accelerator', 'backwpup', 'easy-fancybox', 'pushpress', 'syntaxhighlighter', 'tinymce-advanced', 'wp-crontrol', 'wp-page-numbers', 'wp-social-bookmarking-light', 'wptouch' ]
