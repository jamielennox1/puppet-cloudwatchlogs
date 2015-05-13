# Cloudwatch Logs configuration.

class cloudwatchlogs::config {

  file { '/etc/awslogs':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { '/var/awslogs':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { '/var/awslogs/etc':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/var/awslogs'],
    before  => [
      File['/var/awslogs/etc/awslogs.conf'],
    ],
  }

  concat { '/etc/awslogs/awslogs.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/awslogs'],
  }
  concat::fragment{ 'awslogs_header':
    target  => '/etc/awslogs/awslogs.conf',
    content => template('cloudwatchlogs/awslogs.conf.erb'),
    order   => '01',
  }

  file { '/var/awslogs/etc/awslogs.conf':
    ensure  => 'link',
    target  => '/etc/awslogs/awslogs.conf',
    require => Concat['/etc/awslogs/awslogs.conf'],
  }

}
