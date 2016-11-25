# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "gbarbieru/xenial"
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "10000"
    vb.cpus = 4
  end

  # Install prerequisites
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
  SHELL

  # Changing ARP announce config. Don't know why this is not handled properly.
  config.vm.provision "shell", inline: <<-SHELL
    sysctl -w net.ipv4.conf.all.arp_announce=2
  SHELL

  # Install docker
  config.vm.provision "shell", inline: <<-SHELL
    apt-get install -y apt-transport-https ca-certificates
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | tee /etc/apt/sources.list.d/docker.list
    apt-get update
    apt-get install -y docker-engine
  SHELL

  config.vm.provision "shell", path: "create-cluster.sh"

end
