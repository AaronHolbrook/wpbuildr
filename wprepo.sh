#!/bin/bash
clear
echo "------------------------------------------------------"

mkdir html
cd html
pwd

# initialize git repo
git init

# set .gitignore to ignore wp-config.local so we can set different database variables for development vs production
echo ".DS_Store
wp-config.local.php
wp-content/uploads/
wp-content/cache/
wp-content/advanced-cache.php
*.tmproj
.htaccess" > .gitignore

# copy over a template file of wp-config.local
cat ~/Dropbox/Sites/__TOOLS/wordpress-config/wp-config.local.php > wp-config.local.php

# # download wordpress, extract and delete original tar
wget http://wordpress.org/latest.tar.gz
tar --strip-components=1 -zxvf latest.tar.gz
rm latest.tar.gz
rm license.txt
rm readme.html

# copy over the dev theme
cp -r ~/Dropbox/Sites/__TOOLS/a7-skeleton/ wp-content/themes/$1

# do an initial commit
git add .
git commit -am "initial commit"

# go to plugins and clean it out
cd wp-content/plugins
rm -rf akismet
rm hello.php

# Developer plugin
mkdir developer
cd developer
wget http://downloads.wordpress.org/plugin/developer.zip
tar --strip-components=1 -zxvf developer.zip
rm developer.zip
cd ..

# wp dummy content
mkdir wp-dummy-content
cd wp-dummy-content/
wget http://downloads.wordpress.org/plugin/wp-dummy-content.zip
tar --strip-components=1 -zxvf wp-dummy-content.zip
rm wp-dummy-content.zip
cd ..

# debug bar!
mkdir debug-bar
cd debug-bar
wget http://downloads.wordpress.org/plugin/debug-bar.zip
tar --strip-components=1 -zxvf debug-bar.zip
rm debug-bar.zip
cd ..

# debug bar console
mkdir debug-bar-console
cd debug-bar-console
wget http://downloads.wordpress.org/plugin/debug-bar-console.zip
tar --strip-components=1 -zxvf debug-bar-console.zip
rm debug-bar-console.zip
cd ..

mkdir debug-bar-extender
cd debug-bar-extender
wget http://downloads.wordpress.org/plugin/debug-bar-extender.zip
tar --strip-componenst=1 -zxvf debug-bar-extender.zip
rm debug-bar-extender.zip
cd ..

mkdir debug-bar-query-tracer
cd debug-bar-query-tracer
wget http://downloads.wordpress.org/plugin/debug-bar-query-tracer.zip
tar --strip-components=1 -zxvf debug-bar-query-tracer.zip
rm debug-bar-query-tracer.zip
cd ..

mkdir ultimate-coming-soon-page
cd ultimate-coming-soon-page
wget http://downloads.wordpress.org/plugin/ultimate-coming-soon-page.zip
tar --strip-components=1 -zxvf ultimate-coming-soon-page.zip
rm ultimate-coming-soon-page.zip
cd ..

# regenerate thumbs
mkdir regenerate-thumbnails
cd regenerate-thumbnails
wget http://downloads.wordpress.org/plugin/regenerate-thumbnails.zip
tar --strip-components=1 -zxvf regenerate-thumbnails.zip
rm regenerate-thumbnails.zip
cd ..


cd ../../ 

echo "<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to \"wp-config.php\" and fill in the values.
 *
 * @package WordPress
 */
// For local development - make sure to add wp-config.local.php to your .gitignore file - this file should NOT be on the production server
if ( file_exists( dirname( __FILE__ ) . '/wp-config.local.php' ) ) {
  include( dirname( __FILE__ ) . '/wp-config.local.php' );
  define( 'WP_LOCAL_DEV', true ); 
} 
else {

	// ** MySQL settings - You can get this info from your web host ** //
	/** The name of the database for WordPress */
	define('DB_NAME', '');

	/** MySQL database username */
	define('DB_USER', '');

	/** MySQL database password */
	define('DB_PASSWORD', '');

	/** MySQL hostname */
	define('DB_HOST', '');
	
	define('WP_CACHE', true);


	/**
	 * For developers: WordPress debugging mode.
	 *
	 * Change this to true to enable the display of notices during development.
	 * It is strongly recommended that plugin and theme developers use WP_DEBUG
	 * in their development environments.
	 */
	define('WP_DEBUG', false);

	define('SAVEQUERIES', true);

	/**
	 * WordPress Database Table prefix.
	 *
	 * You can have multiple installations in one database if you give each a unique
	 * prefix. Only numbers, letters, and underscores please!
	 */
	\$table_prefix  = 'wp_';

}


/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@-*/

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */

 " > wp-config.php

curl https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php;

echo "

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');" >> wp-config.php


# define wp-config.local
echo "<?php
define('DB_NAME', '$1');
/** MySQL database username */
define('DB_USER', 'root');
/** MySQL database password */
define('DB_PASSWORD', 'root');
/** MySQL hostname */
define('DB_HOST', 'localhost');

// Open your eyes!
define('WP_DEBUG', true);

// Save queries
define('SAVEQUERIES', true);

\$table_prefix  = 'wp_$1_'; 
?>" > wp-config.local.php

# create local database
/Applications/MAMP/Library/bin/mysql -uroot -proot -e "CREATE DATABASE $1"

echo "------------------------------------------------------"
echo "DATABASE CREATED (hopefully)"
echo "------------------------------------------------------"



#wp plugin activate debug-bar
#wp plugin activate regenerate-thumbnails
#wp plugin activate developer


echo "------------------------------------------------------"
echo "script finished"

