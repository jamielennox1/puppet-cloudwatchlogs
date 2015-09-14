# Cloudwatch Logs credential file configuration.

define cloudwatchlogs::cli (
  $region = undef,
) {

  # Grab the credentials.
  $aws_access_key_id     = hiera('cloudwatchlogs_key_id',     undef)
  $aws_secret_access_key = hiera('cloudwatchlogs_access_key', undef)

  # Profile, only on boxes with an unmanaged credentials file.
  $profile               = hiera('cloudwatchlogs_profile',    undef)

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

  if $profile {
    file { '/var/awslogs/bin/awslogs-agent-launcher.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('cloudwatchlogs/awslogs-agent-launcher.sh.erb'),
      require => Exec['cloudwatchlogs-install'],
      notify  => Service['awslogs'],
    }
  }
}
