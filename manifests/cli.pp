# Cloudwatch Logs credential file configuration.

define cloudwatchlogs::cli (
  $region = undef,
) {

  # Grab the credentials.
  $aws_access_key_id     = hiera('cloudwatchlogs_key_id',     undef)
  $aws_secret_access_key = hiera('cloudwatchlogs_access_key', undef)

  if $region and $aws_access_key_id and $aws_secret_access_key {
    file { '/etc/awslogs/aws.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/awslogs'],
      notify  => Service['awslogs'],
      content => template('cloudwatchlogs/aws.conf.erb'),
    }

    file { '/var/awslogs/etc/aws.conf':
      ensure  => 'link',
      target  => '/etc/awslogs/aws.conf',
      require => File['/etc/awslogs/aws.conf'],
    }
  }

}
