# -*- mode: ruby -*-
# vi: set ft=ruby :

File.open('config.sh', 'r').each_line do |line|
  line = line.chomp.lstrip
  next if line.start_with? '#'
  next if line.empty?
  k,v = line.split('=', 2)
  ENV[k] = v
end

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_check_update = false
  config.vm.network "public_network", bridge: 'wlan2', ip: ENV['V_IP_ADDRESS']
  config.vm.synced_folder ENV['V_KITS_DIRECTORY'], "/kits"
  config.vm.network :forwarded_port, guest: ENV['V_PORT'], host: ENV['V_PORT']
  config.vm.network :forwarded_port, guest: 22, host: ENV['V_VAGRANT_SSHPORT'], id: "ssh"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = ENV['V_VAGRANT_MEMORY']
    vb.gui = ENV['V_VAGRANT_GUI']
  end
  config.vm.provision "shell", inline: "/vagrant/scripts/install.sh"
end
