vagrant-puppet
==============

This git repository provides a sandbox for testing new puppet code

##### Features
* Puppet master, 3 agent VMs
* Automated Puppet Enterprise Install
* R10k deployment of modules in dynamic environments
* Git cloning with SSH Keys
* Easier Provisioning using Puppet

## Prerequisites
* VirtualBox  
```
https://www.virtualbox.org/wiki/Downloads
```
* Vagrant  
```
https://www.vagrantup.com/downloads.html
```

## Getting Started
After cloning the repository you will need to install two Vagrant plugins  
* vagrant-pe_build (`vagrant plugin install vagrant-pe_build`)  
* vagrant-hosts (`vagrant plugin install vagrant-hosts`)  

When these plugins are installed you can start the Puppet master VM  
```bash
vagrant up master
```  

Once the puppet master is fully provisioned you can then start the agent VMs up  

```bash
vagrant up agent1  
vagrant up agent2  
vagrant up agent3
```

## Access PE Console
You can access the Puppet Enterprise Console by going to  
```
https://localhost:8443
```

The login credentials are:  
`Username - admin@yzguy.local`  
`Password - vagrant`

## Project Structure
```bash
vagrant-puppet/
├── answers
│   └── master.txt
├── provision
│   ├── manifests
│   │   └── default.pp
│   ├── modules
│   │   ├── dotfiles
│   │   │   ├── manifests
│   │   │   │   └── init.pp
│   │   │   └── templates
│   │   │       └── gitconfig
│   │   ├── puppet_settings
│   │   │   ├── files
│   │   │   │   └── hiera.yaml
│   │   │   └── manifests
│   │   │       ├── agent.pp
│   │   │       ├── hiera.pp
│   │   │       ├── init.pp
│   │   │       └── master.pp
│   │   ├── r10k
│   │   │   ├── manifests
│   │   │   │   └── init.pp
│   │   │   └── templates
│   │   │       └── r10k.yaml.erb
│   │   └── ssh_keys
│   │       ├── files
│   │       │   ├── empty_file
│   │       │   ├── id_rsa
│   │       │   ├── id_rsa.pub
│   │       │   └── known_hosts
│   │       └── manifests
│   │           └── init.pp
│   └── scripts
│       ├── path.sh
│       └── r10k.sh
├── README.markdown
└── Vagrantfile
```
All the provisioning items are in the provision directory, this is where you add new things that you need to do when you provision the VM

#### Puppet Version and Box Settings
```ruby
pe_version = '3.3.2'
master_box = 'chef/centos-6.5'
agent1_box = 'chef/centos-6.5'
agent2_box = 'chef/centos-6.5'
agent3_box = 'chef/centos-6.5'
```
You can change the variables at the top of the Vagrant file to change the version of Puppet Enterprise, as well as the box that the VM will use as a base
You can also specify the location of the box if needed

#### Puppet Provisioning
You have the ability to use puppet to help provision the vagrant box after pe_build finished installing PE.
The `modules/` and `manifests/default.pp` file is where you will need to add your configuration.

It comes with some already created configuration for modifying puppet settings, r10k, and ssh_keys  

```puppet
node 'puppet.yzguy.local' {
  class { 'puppet_settings::master': }
  class { 'puppet_settings::agent':
    environment => 'production'
  }
  class { 'puppet_settings::hiera': }
  class { 'ssh_keys': }
  class { 'dotfiles':
    git_email => 'zero1three@gmail.com',
    git_name => 'Adam Smith',
  }
  class { 'r10k':
    git_repo   => 'git@bitbucket.org:yzguy/yzguy-profiles.git',
    hiera_repo => 'git@bitbucket.org:yzguy/puppetfile.git',
  }
}

node 'agent1.yzguy.local' {
  class { 'puppet_settings::agent':
    environment => 'production'
  }
}

node 'agent2.yzguy.local' {
  class { 'puppet_settings::agent':
    environment => 'production'
  }
}

node 'agent3.yzguy.local' {
  class { 'puppet_settings::agent':
    environment => 'production'
  }
}
```
You have the option of changing the environment for which the master is in, as well as each puppet agent, you can also change the URL for the puppetfile.

### SSH Keys
If you are going to be using SSH keys for git/r10k, you will need to add them in the
provision/modules/ssh_keys/files
```
id_rsa
id_rsa.pub
```
You may also need to add entries to `known_hosts` so that r10k won't hang the first time it runs because it cannot
establish the authenticity of the remote host

```puppet
class { 'ssh_keys': }
```
in the provision/manifests/default.pp file so that your keys will be added to the vagrant box when it is provisioned

If you are going to use HTTPS, then you need to comment out the ssh_keys class in the provision/manifests/default.pp file

### Dotfiles
Dotfiles within the puppet master are created when the VM is provisioned and can be modified in the provisoning module

Currently the dotfiles managed are  

```bash
.gitconfig
```

The git config is managed as well, inside the provision/manifests/default.pp you will need to change the variables to fit you.

```puppet
class { 'dotfiles':
  git_email => 'zero1three@gmail.com',
  git_name => 'Adam Smith',
}
```

### R10k
You may need to edit the `provision/manifests/default.pp`, to provide a URL to your puppetfile repository

```puppet
class { 'r10k':
  git_repo   => 'git@bitbucket.org:yzguy/yzguy-profiles.git',
  hiera_repo => 'git@bitbucket.org:yzguy/puppetfile.git',
}
```
If you are using SSH Keys, make sure your puppetfile URL is the SSH URL, if you are not using SSH keys, make sure it is the HTTPS one
