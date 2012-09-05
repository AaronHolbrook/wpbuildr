#!/bin/bash
#
# This script was created to cut down on the amount of time it takes
# to get a local install of WordPress up and running by automating the
# things we do over and over: download WordPress, create a database, run the
# install, download our favorite plugins, etc, etc.
#
# Additionally, this script is meant to help with multi-environment deployment
# using Aaron Holbrook's WordPress/Git deployment model (http://aaronjholbrook.com/?=310)
#
# Created by Aaron Holbrook aaron@a7web.com
#
#

clear
echo ""
echo "     Welcome to Aaron Holbrook's interactive WP Automation Script!      "
echo '  _ _ _           _ _____                    _____     _ _   _          '
echo ' | | | |___ ___ _| |  _  |___ ___ ___ ___   | __  |_ _|_| |_| |___ ___  '
echo ' | | | | . |  _| . |   __|  _| -_|_ -|_ -|  | __ -| | | | | . | -_|  _| '
echo ' |_____|___|_| |___|__|  |_| |___|___|___|  |_____|___|_|_|___|___|_|   '
echo '                                                                        '
echo '          @aaronjholbrook | http://a7web.com | aaron@a7web.com          '
echo '------------------------------------------------------------------------'
echo " "


# create the html for site-root (to mimic MT, possibly look at allowing other structures)
# if html dir exists, exit - let's not break anything!
if [ -d "html" ]; then
	echo "Oops, looks like you already have an html directory here!"
	echo "exiting..."
	exit
fi

# Set path of script for our library files
dir=`dirname $0`


# See if there's a config file, if not offer to create one based on the options the 
# user chooses during the setup
if [ ! -e "$dir/conf/config.conf" ]; then
	read -p 'Would you like to save your config for next time? [Y/n]' response
	if [[ $response =~ ^([nN][oO]|[nN])$ ]]
		then
				config="NO"
		else
		    config='YES'
		    declare -a config_values
		    touch $dir/config.conf
	fi
	# Cool there's already a config file, so let's use those defaults!
	else
		echo "Detected a config file, using those defaults."
fi


# Create html directory (todo: customizable structure)
mkdir html; cd html

# Build our theme from a framework? 
echo "What theme framework would you like to use?"
read -p "Options: [_s, startbox, starkers, html5, bones, custom, none]" config_values["framework"]

# Init git repo and do an empty initial commit (for rebasing, thanks @evansolomon)
git init
git commit --allow-empty -m "Initial empty commit"

# set .gitignore to ignore wp-config.local so we can set different database variables for development vs production
cat "$dir/lib/.gitignore" > .gitignore

# copy over a template file of wp-config.local
#cat "$dir/lib/wp-config.local.php" > wp-config.local.php

# download wordpress, extract and delete original tar
wget http://wordpress.org/latest.tar.gz
tar --strip-components=1 -zxvf latest.tar.gz
rm latest.tar.gz
rm license.txt
rm readme.html

# We succesfully added WordPress, so let's commit!
git add .
git commit -am "WordPress installed!"


# Use framework option
if [ ${config_values["framework"]} == "_s" ]; then
  framework_repo="git://github.com/Automattic/_s.git"
elif [ ${config_values["framework"]} == "startbox" ]; then
	framework_repo="git://github.com/brichards/StartBox.git"  
elif [ ${config_values["framework"]} == "starkers" ]; then
	framework_repo="git://github.com/viewportindustries/starkers.git"
elif [ ${config_values["framework"]} == "html5"]; then
	framework_repo="git://github.com/murtaugh/HTML5-Reset-Wordpress-Theme.git"  
elif [ ${config_values["framework"]} == "bones" ]; then
	framework_repo="git://github.com/eddiemachado/bones.git"
elif [ ${config_values["framework"]} == "roots" ]; then
	framework_repo="git://github.com/retlehs/roots.git"
elif [ ${config_values["framework"]} == "a7" ]; then
  framework_repo="git://github.com/AaronHolbrook/a7_start.git"
elif [ ${config_values["framework"]} == "custom" ]; then
  read -p "Location for custom theme: [can be git:// protocol or just a local git repository]" config_values["framework_custom"]
elif [ ${config_values["framework"]} == "none" ]; then
	framework_repo="none"
fi

# if the user did not choose none, then add the theme to our themes folder
if [ $framework_repo != "none" ]; then
	# clone the repo into our new base directory
	git clone $framework_repo "wp-content/themes/"$1

	# let's clear out one of the pre-packaged themes
	rm -rf wp-content/themes/twentyten
fi

# Cool - we added our theme, let's commit!
git add .
git commit -am "Theme framework installed!"

# Clean out packaged plugins (akismet & hello dolly)
cd wp-content/plugins
rm -rf akismet
rm hello.php

#
# Install plugins that are listed in the plugins.conf file
# To add your/modify the plugins that are installed simply
# Change the plugins file to contain the slug of the plugins you want!
# 
for plugin in `cat $dir/conf/plugins.conf`; do
	echo "Installing: $plugin..."
	mkdir $plugin; cd $plugin
	wget http://downloads.wordpress.org/plugin/$plugin.zip
	tar --strip-components=1 -zxvf $plugin.zip
	rm $plugin.zip
	cd ..
done

# cool, plugins are installed, let's commit!
git add .
git commit -am "Plugins installed!"


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

# All done with wp-config.php so let's remove that wp-config-sample.php file
rm wp-config-sample.php


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

# cool, wp-config(s) has been created, let's commit!
git add .
git commit -am "wp-config & wp-config.local created!"

# create local database
/Applications/MAMP/Library/bin/mysql -uroot -proot -e "CREATE DATABASE $1"

echo ''
echo '                     _                                                             __'
echo '   __  ______  __  _( )________     ____ __      _____  _________  ____ ___  ___  / /'
echo '  / / / / __ \/ / / /// ___/ _ \   / __ `/ | /| / / _ \/ ___/ __ \/ __ `__ \/ _ \/ / '
echo ' / /_/ / /_/ / /_/ / / /  /  __/  / /_/ /| |/ |/ /  __(__  ) /_/ / / / / / /  __/_/  '
echo ' \__, /\____/\__,_/ /_/   \___/   \__,_/ |__/|__/\___/____/\____/_/ /_/ /_/\___(_)   '
echo '/____/                                                                               '
echo ''
echo "If you found this useful I'd love to know! Hit me up at @aaronjholbrook"
echo "You're all done, now go drink a beer!"



