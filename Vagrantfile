# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'rake'

# Load Config File
config = YAML.load_file 'config.yml'

# Run setup Rake task
# Write out answers file
# Write out puppet manifest
# Copy in SSH Keypair, Known Hosts
load 'Rakefile'
Rake::Task[:setup].invoke

Vagrant.configure('2') do |vagrant|
  vagrant.pe_build.version = config[:puppet][:version]
  vagrant.pe_build.download_root = config[:puppet][:url] + config[:puppet][:version]
  vagrant.vm.box_check_update = config[:vm][:box_check_update]

  # Puppetmaster configuration
  vagrant.vm.define 'master' do |master|
    # VM Configuration
    master.vm.box = config[:master][:box]
    master.vm.hostname = config[:master][:hostname]
    master.vm.network :private_network, ip: config[:master][:ip]

    # VM Resource Configuration
    master.vm.provider :virtualbox do |vbox|
      vbox.customize ['modifyvm', :id, '--name', config[:master][:hostname]]
      vbox.memory = config[:master][:memory]
      vbox.cpus = config[:master][:cpu]
    end

    # Shell Script to Fix puppet in $PATH
    master.vm.provision :shell, path: config[:provision][:path_fix_path]

    # Hosts File Configuration
    master.vm.provision :hosts do |hosts|
      hosts.add_host config[:master][:ip], [config[:master][:hostname]]
      hosts.add_host config[:node1][:ip],  [config[:node1][:hostname]]
      hosts.add_host config[:node2][:ip],  [config[:node2][:hostname]]
      hosts.add_host config[:node3][:ip],  [config[:node3][:hostname]]
    end

    # pe_build Configuration
    master.vm.provision :pe_bootstrap do |pe|
      pe.role = :master
      pe.answer_file = config[:puppet][:answer_file]
    end

    # Provision VM with Puppet
    master.vm.provision :puppet do |puppet|
      puppet.manifests_path = config[:puppet][:manifests_path]
      puppet.module_path = config[:puppet][:module_path]
    end

    # Run r10k
    master.vm.provision :shell, path: config[:provision][:r10k_path]
  end

  [:node1, :node2, :node3].each do |node|
    vagrant.vm.define node do |n|
      # VM Configuration
      n.vm.box = config[node][:box]
      n.vm.hostname = config[node][:hostname]
      n.vm.network :private_network, ip: config[node][:ip]

      # VM Resource Configuration
      n.vm.provider :virtualbox do |vbox|
        vbox.customize ['modifyvm', :id, '--name', config[node][:hostname]]
        vbox.memory = config[node][:memory]
        vbox.cpus = config[node][:cpu]
      end

      # Shell script to fix puppet in $PATH
      n.vm.provision :shell, path: config[:provision][:path_fix_path]

      # Host File Configuration
      n.vm.provision :hosts do |hosts|
        hosts.add_host config[:master][:ip], [config[:master][:hostname]]
        hosts.add_host config[:node1][:ip],  [config[:node1][:hostname]]
        hosts.add_host config[:node2][:ip],  [config[:node2][:hostname]]
        hosts.add_host config[:node3][:ip],  [config[:node3][:hostname]]
      end

      # Puppet Bootstrap Configuration
      n.vm.provision :pe_bootstrap do |pe|
        pe.role = :agent
        pe.master = config[:master][:hostname]
      end

      # Provision with Puppet
      n.vm.provision :puppet do |puppet|
        puppet.manifests_path = config[:puppet][:manifests_path]
        puppet.module_path = config[:puppet][:module_path]
      end
    end
  end
end
