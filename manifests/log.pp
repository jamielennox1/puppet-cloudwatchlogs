# Append a log to the Cloudwatch Logs.

define cloudwatchlogs::log (
  $group = '',
) {

  # Since we have logs. Might as well install as well.
  if ! defined(Class['cloudwatchlogs::install']) {
    include cloudwatchlogs::install
  }

  concat::fragment{ $title:
    target  => '/etc/awslogs/awslogs.conf',
    content => template('cloudwatchlogs/awslog.conf.erb'),
    order   => '02'
  }

}
