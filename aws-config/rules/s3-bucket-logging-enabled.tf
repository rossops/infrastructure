module "s3_bucket_logging_enabled" {
  source = "../modules/rules"

  rule_name                        = "s3-bucket-logging-enabled"
  rule_description                 = "Checks whether logging is enabled for your S3 buckets."
  rule_compliance_resource_types   = ["AWS::S3::Bucket"]
  rule_source_identifier           = "S3_BUCKET_LOGGING_ENABLED"
}
