# VagrantDockerSites
This repo provides two methods (Vagrant and Docker) to perform a fully unattended installation of Oracle WebCenter Sites including OS, application server, DB, Sites and patches.

Both methods produce an Oracle WebCenter Sites 11.1.1.8.0 patch 11 single server development installation with cas, AviSports sample site, and optionally support tools 4.4. It uses java 1.7, tomcat 7 and hsqldb 1.8, on centos 6.

The Vagrant method uses a virtualbox provider and shell provisioner scripts to do the installation work. It requires the kits (sites, tomcat, etc) to be downloaded in advance to a local disk which are then made available to the virtualbox in the /kits directory.

The Docker method uses exactly the same underlying scripts to perform the installation. It does not require any kits to be downloaded, instead it downloads them automatically, using Oracle website credentials to download the Sites kit. Additionally the docker method allows startup of multiple simultaneous containers, e.g. editorial and delivery, defined in docker-compose.yml.

*These scripts are not an official Oracle product, and the stack they produce is not supported (centos, hsqldb).*

### Usage - Vagrant:

1. Install vagrant
2. Create a directory to store the installation kits, eg /home/phil/Documents/kits
3. Obtain the following, and put in the kits directory
  * jdk-7u79-linux-x64.tar.gz
  * apache-tomcat-7.0.62.tar.gz
  * hsqldb_1_8_0_10.zip
  * ofm_sites_generic_11.1.1.8.0_disk1_1of1.zip (webcenter sites 11.1.1.8.0 kit from OTN)
  * p21494888_111180_Generic.zip (webcenter sites 11.1.1.8.0 patch 11 kit from oracle support)
  * optional: p22093196_111180_Generic.zip (webcenter sites support tools 4.4 from oracle support)
4. Clone this repository, e.g. git clone https://github.com/pgleghorn/VagrantSites.git
5. Edit config.sh and change required params
 * set V_KITS_DIRECTORY to the directory from step 2
 * set V_HOSTNAME to the desired hostname
 * set V_IP_ADDRESS to the desired IP address
 * set V_PORT to the desired port
6. Run "vagrant up" to install everything.

It takes about 5 minutes to install everything (longer the first time, as the centos box is downloaded)

The Network is bridged, and presumes existence of "wlan2", if that does not exist then vagrant will prompt to ask which adapter it should use.

### Usage - Docker:

1. Install docker and docker-compose
2. Clone this repository, e.g. git clone https://github.com/pgleghorn/VagrantSites.git
3. Set environment variables ORACLE_USER and ORACLE_PASSWORD with your oracle credentials.
4. Edit config.sh and change any required params
5. Build the docker images with:  ./buildDockerImage.sh
6. Edit docker-compose.yml and define the instances to startup (e.g. editorial:5001, and delivery:5002)
7. Startup with: docker-compose up

To reach Sites you will need to add a local hosts mapping to point to the hostname(s) selected in docker-compose.yml. Note that since Sites needs to know at install-time which host:port it lives at, using docker port mapping to set a different host vs container port will not work, Sites will redirect the user to the port it knows about.

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
* psi-probe
* ~~dont require cygwin/linux~~
* proper xml file editing (eg augeas) not sed
* dont bake oracle credentials into the docker image history
* vagrantfile should be able to downloads kits also
* test on more host platforms
* expand to include sites12c
* ~~split dockerfile into multiple images (base download of kits, vs install/configure)~~
* some way to facilitate proper docker port mapping at runtime
* ~~docker-compose for startup~~
* ~~multiple simultaneous containers~~
* ~~set host:port dynamic on first startup, startupDynamic.sh~~
