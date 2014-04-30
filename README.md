TinyPub, is a Ruby Sinatra  application written by CrossRef in order to demonstrate how a publisher site should interact with the Text and Data API and Click-Through Service.


For more information on how Text and Data Mining, see [https://apps.crossref.org/docs/tdm](https://apps.crossref.org/docs/tdm). For more information about the Click-Through Service see [https://apps.crossref.org/docs/clickthrough](https://apps.crossref.org/docs/clickthrough)

Version 1.0 of the application was released in July 2013 and has been updated to be compatible with Ruby 1.9.3, Sinatra 1.4.2. It uses sqlite3 as the database backend.


## Installation

Tinypub is a typical Sinatra web application with the following requirements:

* Ruby 1.9.3
* sqlite3 1.7.9

#### Ruby 1.9
ALM requires Ruby 1.9.3. Not all Linux distributions include Ruby 1.9 as a standard install, which makes it more difficult than it should be. [RVM][rvm] and [Rbenv][rbenv] are Ruby version management tools for installing Ruby 1.9. Unfortunately they also introduce additional dependencies.

#### Installation Options
The easiest way to install the application is to use the bundler gem. After the bundler gem is installed, you should just be able to CD to the source directlty and execute:

    bundle install --path vendor/bundle

Copy the sample file config/__application.yml to config/application.yml and adjust the settings to match your environment.

After which running the following should start the server.

    bundle exec rackup

#### Running under Apache/Passenger

If you want to run the application behind Apache using passenger, there is a sample virtual host file in the config directory.

### Note that, to use HTTPS you can easily create a self-signed certificate as follows:

    sudo /usr/sbin/make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/server_name.pem

After which you must direct your above virtual host file to the certificate you just created.

#### Verifying that things are working

You should simply be able to connect to the home page of your virtual host to verify that the site is working and the settings are correct.

#### Add IP addresses for testing subscriptions

To test the system with "subscriptions" enabled, remember that you will need to add the IP address of the client to the access control system. You can do this using the add_subscriber script in the tools folder like this:

    tools/add_subscriber "Name of subscriber" xxx.xxx.xxx.xxx

 
