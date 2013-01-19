WPBuildr
=================

WPBuildr automates the set up a WordPress install complete with theme framework of your choice, a git repository with an empty initial commit (for easy rebasing), plugins of your choice, database creation and creation of wp-config file complete with unique RSA salts.

Who it's for
============

This is primarily for developers that need to set up WordPress installations quite frequently and have gotten annoyed at spending time on automatable actions.


What it automates
============

* Downloads and extracts WordPress
* Configures DB information
* Installs or copies your starter theme or framework
* Removes the Hello, Dolly plugin
* Downloads or installs your favorite development plugins
* Sets up a git repository, with commits during all stages of installation


Requirements
===========

* Mac OS X >= 10.5
* MAMP
* `Bash` >= 3.2
* `wget` (does not come pre-installed, you must download/install via HomeBrew or some other way)

Running
=======

Place the folder within your Bash path (`/usr/local/sbin/`, `/usr/local/`) or add it to your Bash profile path.

Via the command line, navigate to your desired placement of your new WordPress install, simply run `wpbuildr`. 

`wpbuildr` accepts one argument at the command line, which is the intended name of your project. This argument is used to create the database name, theme folder and the table prefix.

Example usage: `$ wpbuildr mywwpinstall` would create a database and theme folder named 'mywpinstall'

Enjoy your new WordPress install!

Customizing Plugins
===================

Simply add or remove the slug of the plugins you want WPBuildr to install to the `conf/plugins.conf` file!
