# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.define "test" do |test|
    test.vm.network "private_network", ip: "192.168.33.3"
  end
end

# [provision command]:
# ansible-playbook -i tests/vagrant-inventory tests/test.yml