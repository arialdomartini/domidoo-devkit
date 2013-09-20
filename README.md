domidoo-devkit
==============

This is the python developers kit for the Domidoo project.

This package contains what's needed to develop Domidoo and deploy it on a dedicate server.


Requirements
============
* A Mac
* [homebrew](http://brew.sh/) installed
* The ssh password for (a) dedicate domidoo server's root user.


Build
=====
Clone this repo. Then run

    ./build.sh

You will be asked for the remote server root's password.

After the first run, you should be able to ssh and ansible the remote server with no password, by the means of your ssh key.
 
