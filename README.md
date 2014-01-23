dashing-nagios
==============

dashing-nagios is a widget for Shopify's dashing framework to display Nagios warning and error counts

This repo contains the nagios widget, a sample dashboard using the nagios widget, and a job to fetch data from one or more Nagios instances.

Configuration
=============

Copy the contents of jobs, assets and widgets directories to your dashing
installation. You may also copy the sample nagios dashboard if you wish.

Add the content of Gemfile.nagios to your dashing Gemfile and run
`bundle install` to install dependencies.

Edit jobs/nagios.rb and change the URL, username and password of your
Nagios server.

Screenshot
==========

![image](https://raw.github.com/aelse/dashing-nagios/master/assets/dashing-nagios-example.png)
