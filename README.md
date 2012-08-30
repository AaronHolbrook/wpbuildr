WordPress Builder
=================

WordPress Builder automates the set up a WordPress install complete with theme framework of your choice, a git repository complete with an empty initial commit (for easy rebasing), plugins of your choice, database creation and creation of wp-config file complete with unique RSA salts.

Requirements
===========

* Bash >= 3.2

Running
=======

Place the folder within your Bash path (`/usr/local/sbin/`, `/usr/local/`) or add it to your Bash profile path.

Via the command line, navigate to your desired placement of your new WordPress install, simply run `wpbuildr.sh`. 

`wpbuildr.sh` accepts one argument at the command line, which is the intended name of your project. This argument is used to create the database name, theme folder and the table prefix.