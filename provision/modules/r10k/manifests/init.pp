class r10k (
    $git_repo = '',
    $version = 'latest',
) {
  package { 'git':
    ensure => present,
  }

  if $version != 'latest' {
    $command = "gem install r10k -v ${version}"
  } else {
    $command = 'gem install r10k'
  }

  exec { 'install_r10k':
    command   => $command,
    path      => '/opt/puppet/bin',
    logoutput => true,
    user      => 'root',
  }

  file { '/usr/local/bin/r10k':
    ensure  => link,
    target  => '/opt/puppet/bin/r10k',
    require => Exec['install_r10k'],
  }

  file { 'r10k.yaml':
    ensure  => present,
    path    => '/etc/r10k.yaml',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('r10k/r10k.yaml.erb'),
  }

}
