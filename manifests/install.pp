# Install Cloudwatch Logs.

class cloudwatchlogs::install {

  # Only need the region here, do not load the auth creds. Default to
  # us-east-1 because, but whine if we do. Basically: set a region, mate.
  $region = hiera('cloudwatchlogs_region', undef)

  if !$region {
    $_region = 'us-east-1'
    notice('No region defined for cloudwatchlogs, defaulting to us-east-1.')
  } else {
    $_region = $region
  }

  # Pass the region to the credentials file.
  cloudwatchlogs::cli { 'credentials':
    region => $_region,
  }
  include cloudwatchlogs::config
  include cloudwatchlogs::service

  if ! defined(Package['wget']) {
    package { 'wget':
      ensure => 'present',
    }
  }

  exec { 'cloudwatchlogs-wget':
    path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
    command => 'wget -O /usr/local/src/awslogs-agent-setup.py https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py',
    unless  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
  }

  exec { 'cloudwatchlogs-install':
    path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
    command => "python /usr/local/src/awslogs-agent-setup.py -n -r ${_region} -c /etc/awslogs/awslogs.conf",
    onlyif  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
    unless  => '[ -d /var/awslogs/bin ]',
    require => File['/etc/awslogs/awslogs.conf'],
    before  => Service['awslogs'],
  }

}
