# -*- mode: ruby -*-
# vi: set ft=ruby :

_ver="VagrantSites 1.0"
puts _ver
Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_check_update = false
  config.vm.hostname = ENV['V_HOSTNAME']
  config.vm.network "public_network", bridge: 'wlan2', ip: ENV['V_IP_ADDRESS']
  config.vm.synced_folder ENV['V_KITS_DIRECTORY'], "/kits"
  config.vm.network :forwarded_port, guest: ENV['V_PORT'], host: ENV['V_PORT']
  config.vm.network :forwarded_port, guest: 22, host: ENV['V_VAGRANTSSHPORT'], id: "ssh"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.gui = true
  end
  config.vm.provision "shell", inline: "/vagrant/scripts/install.sh"
end
