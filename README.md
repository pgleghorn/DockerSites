# VagrantSites
Vagrant script to perform a fully unattended installation of Oracle WebCenter Sites including OS, application server, DB, Sites and patches.

This Vagrantfile gives an Oracle WebCenter Sites 11.1.1.8.0 patch 11 single server development installation with cas, AviSports sample site, and support tools 4.3. It uses tomcat 7 and hsqldb 1.8, on centos 6.6. This uses a virtualbox provider, and shell provisioner script to do the installation work. It presumes cygwin or linux.

*This Vagrantfile is not an official Oracle product, and the stack it produces is not supported (centos, hsqldb).*

### Usage:

1. Install vagrant
2. Create a directory to store the installation kits, eg /home/phil/Documents/kits
3. Obtain the following, and put in the kits directory
  * jdk-7u79-linux-x64.tar.gz
  * apache-tomcat-7.0.62.tar.gz
  * hsqldb_1_8_0_10.zip
  * V38958-01.zip (webcenter sites 11.1.1.8.0 kit from oracle edelivery)
  * p21494888_111180_Generic.zip (webcenter sites 11.1.1.8.0 patch 11 kit from oracle support)
  * SupportTools-4.3.zip (webcenter sites support tools 4.3 from oracle support)
4. Clone this repository, e.g. git clone https://github.com/pgleghorn/VagrantSites.git
5. Edit config.sh and change required params
 * set V_KITS_DIRECTORY to the directory from step 2
 * set V_HOSTNAME to the desired hostname
 * set V_IP_ADDRESS to the desired IP address
 * set V_PORT to the desired port
6. Run "./run.sh" to install everything.

It takes about 5 minutes to install everything (longer the first time, as the centos box is downloaded)

The Network is bridged, and presumes existence of "wlan2", if that does not exist then vagrant will prompt to ask which adapter it should use.

### Todo

* ~~smarter install, dont run twice but instead wait for tomcat startup then continue~~
* ~~dont presume 192.168.x.x network~~
* ~~more configurable (user, directory, port, hostname, etc)~~
* ~~move configurable items into a hiera config file -> .sh file~~
* ~~install supporttools~~
* ~~enable asset forms in admin UI~~
* ~~echo script to run as root in host, to add ip address for v8 to /etc/hosts~~
* rss
* httpd / ohs
* puppetize it all: os / tomcat / sites / patch
* further puppetizing: httpd / vanity url config
* further platform: oel / wls / oraclexe db
* leave behind scripts for easy cmd line catalogmover & csdt
* ssl
* openldap / active directory integration
* wine & sites explorer
* eclipse integration
* clusters
* analytics


