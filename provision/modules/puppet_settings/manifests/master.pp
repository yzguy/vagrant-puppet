class puppet_settings::master {
  include ::puppet_settings::agent

  ini_setting { 'environmentpath':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'environmentpath',
    value   => '$confdir/environments',
  }

  ini_setting { 'basemodulepath':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'basemodulepath',
    value   => '$confdir/modules:/opt/puppet/share/puppet/modules',
  }

  file { 'hiera.yaml':
    ensure => present,
    path   => '/etc/puppetlabs/puppet/hiera.yaml',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppet_settings/hiera.yaml',
  }

  service { 'pe-httpd':
    ensure    => running,
    subscribe => File['hiera.yaml'],
  }
}
