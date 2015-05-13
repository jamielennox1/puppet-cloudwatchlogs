# Cloudwatch Logs configuration.

class cloudwatchlogs::config {

  if $region and $aws_access_key_id and $aws_secret_access_key {
    file { '/var/awslogs/etc/awscli.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/var/awslogs/etc'],
      notify  => Service['awslogs'],
      content => template('cloudwatchlogs/awscli.conf.erb'),
    }
  }

}
