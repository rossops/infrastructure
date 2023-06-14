module "cloudtrail_enabled" {
  source = "../modules/rules"

  rule_name                        = "cloudtrail-enabled"
  rule_description                 = "Checks whether AWS CloudTrail is enabled in your AWS account. Optionally, you can specify which S3 bucket, SNS topic, and Amazon CloudWatch Logs ARN to use."
  rule_input_parameters            = "{\"s3BucketName\":\"cloudtrail.downdetective.com\",\"cloudWatchLogsLogGroupArn\":\"arn:aws:logs:us-east-1:xxxxxxxxxxxxxxxxx:log-group:CloudTrail/DefaultLogGroup:*\"}"
  rule_maximum_execution_frequency = "One_Hour"
  rule_source_identifier           = "CLOUD_TRAIL_ENABLED"
}
