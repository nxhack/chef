<?php
require_once('/etc/wordpress-jp/config-jp.php');

define('WP_CORE_UPDATE', true);
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('ABSPATH', '/var/www/blog/');
define('WP_DEBUG', false);
define('WPLANG', 'ja');

require_once(ABSPATH . 'wp-settings.php');
?>