wp-automated-setup
==================

Shell script to help automate the set up a WordPress install complete with theme framework of your choice (todo), git repository, plugins of your choice (todo), creating database, and automating creation of wp-config file complete with salts.

Running
=======

To run the script simply type the scriptname from the location you wish it to create a new WordPress install. The script accepts one argument which it will use to create the database name and theme folder as.

Examples
========
```
$> wprepo.sh NEWTHEME
```
This creates a database with the name NEWTHEME and a theme folder in /wp-content/themes/NEWTHEME with a skeleton theme (todo: add options for skeleton theme repos, or use custom location)

