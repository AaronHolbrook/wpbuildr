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
* `Bash` >= 3.2 (Comes pre-installed on most Mac Operating Systems)

Running
=======

Add a symbolic link to your `/usr/local/sbin` folder:

```
ln -s ~/wpbuildr /usr/local/sbin/
```

Via the command line, navigate to your desired placement of your new WordPress install, simply run `wpbuildr`. 

`wpbuildr` accepts one argument at the command line, which is the intended name of your project. This argument is used to create the database name, theme folder and the table prefix.

Example usage: `$ wpbuildr mywwpinstall` would create a database and theme folder named 'mywpinstall'

Enjoy your new WordPress install!

Customizing Plugins
===================

Simply add or remove the slug of the plugins you want WPBuildr to install to the `conf/plugins.conf` file!

To Do
=====

- Check if there are mu-plugins
- Integrate SASS

Changelog
=========

**1.3**
* Added additional plugins that are useful to making WP a CMS from the get go

**1.2**
* Added support for native MySQL, first checks for MAMP, falls back to command line MySQL
* Fixed issue with whitespace in project name preventing MySQL database from being created
* Fixed issue with symlink preventing access to library files which would prevent plugins from being downloaded
* Updated startbox repo (had migrated to webdevstudios from brichards)

**1.0**
* Initial release
