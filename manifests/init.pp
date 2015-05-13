# Cloudwatch Logs.

class cloudwatchlogs {

  $files = hiera_hash('cloudwatchlogs_files', false)
  if $drupal {
    create_resources(cloudwatchlogs::log, $files)
  }

}
