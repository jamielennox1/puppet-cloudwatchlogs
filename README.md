CloudWatch Logs
===============

Automated installation and log push for AWS CloudWatch.

## Setup

```puppet
cloudwatchlogs::log { '/var/log/apache2/*access.log':
  group => 'Webserver - Access',
}
```

Note: This definition will include the `cloudwatchlogs` class automatically.
