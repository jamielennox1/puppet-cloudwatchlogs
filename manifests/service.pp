# Cloudwatch Logs service.

class cloudwatchlogs::service {

  service { 'awslogs':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File['/var/awslogs/etc/awslogs.conf'],
  }

}
