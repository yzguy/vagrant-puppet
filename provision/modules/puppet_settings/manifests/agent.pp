class puppet_settings::agent (
  $environment = 'production'
){
  ini_setting { 'environment':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'environment',
    value   => $environment,
  }
}
