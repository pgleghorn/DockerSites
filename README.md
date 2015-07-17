# VagrantSites
First attempt at a Vagrant script to perform a fully unattended installation of Oracle WebCenter Sites including OS, application server, DB, Sites and patches.

Currently using a very basic shell provisioner, using virtualbox provider. This gives an Oracle WebCenter 11.1.1.8.0 patch 10 single server development installation with cas and AviSports sample site. It uses tomcat 7 and hsqldb 1.8, on centos 6.6. 

Usage:

1. Install vagrant
2. Create a directory to store the installation kits, eg /home/phil/Documents/kits
3. Obtain the following, and put in the kits directory

jdk-7u79-linux-x64.tar.gz
apache-tomcat-7.0.62.tar.gz
hsqldb_1_8_0_10.zip
V38958-01.zip (webcenter sites 11.1.1.8.0 kit from oracle edelivery)
p20981509_111180_Generic.zip (webcenter sites 11.1.1.8.0 patch 10 kit from oracle support)

4. Create a directory to store the vagrantfile, eg /home/phil/vagrant/v6
5. Download the Vagrantfile into it
6. Edit the Vagrantfile to update with the location of your kits directory

config.vm.synced_folder "/home/phil/Documents/kits", "/kits"

5. Run "vagrant up", it takes about 10 minutes to install everything.
6. Network is bridged, and presumes existence of "wlan2", if that does not exist then vagrant will prompt to ask which adapter it should use.
7. When complete you should see

Now goto http://n.n.n.n:8080/cs/

8. To access the box by hostname (v6) add an /etc/hosts (or windows equivalent), eg

n.n.n.n v6

where n.n.n.n is the address given after the environment is created. Now you should be able to access like

http://v6:8080/cs/
