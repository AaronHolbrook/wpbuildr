WordPress Builder
=================

WordPress Builder automates the set up a WordPress install complete with theme framework of your choice, a git repository with an empty initial commit (for easy rebasing), plugins of your choice, database creation and creation of wp-config file complete with unique RSA salts.

Who it's for
============

This is primarily for developers that need to set up WordPress installations quite frequently and have gotten annoyed at:

* Downloading and extracting WordPress
* Inputting DB information
* Installing/copying your starter theme or framework
* Downloading or installing your development plugins

This script aims to automate as much of the process as possible.

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

Enjoy your new WordPress install!

Customizing Plugins
===================

Simply add the slug of the plugins you wish WordPress Builder to install to the `conf/plugins.conf` file!