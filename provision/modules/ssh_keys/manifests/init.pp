class ssh_keys {

  file { '/root/.ssh':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/root/.ssh/id_rsa':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source  => 'puppet:///modules/ssh_keys/id_rsa',
    require => File['/root/.ssh'],
  }

  file { '/root/.ssh/id_rsa.pub':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/ssh_keys/id_rsa.pub',
    require => File['/root/.ssh'],
  }

  file { '/root/.ssh/known_hosts':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/ssh_keys/known_hosts',
    require => File['/root/.ssh'],
  }
}
