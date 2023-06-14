module "cloud_trail_cloud_watch_logs_enabled" {
  source = "../modules/rules"

  rule_name                        = "cloud-trail-cloud-watch-logs-enabled"
  rule_description                 = "Checks whether AWS CloudTrail trails are configured to send logs to Amazon CloudWatch logs. The trail is non-compliant if the CloudWatchLogsLogGroupArn property of the trail is empty."
  rule_maximum_execution_frequency = "TwentyFour_Hours"
  rule_source_identifier           = "CLOUD_TRAIL_CLOUD_WATCH_LOGS_ENABLED"
}
