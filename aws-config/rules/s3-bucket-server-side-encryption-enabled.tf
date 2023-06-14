module "s3_bucket_server_side_encryption_enabled" {
  source = "../modules/rules"

  rule_name                        = "s3-bucket-server-side-encryption-enabled"
  rule_description                 = "Checks whether the S3 bucket policy denies the put-object requests that are not encrypted using AES-256 or AWS KMS."
  rule_compliance_resource_types   = ["AWS::S3::Bucket"]
  rule_source_identifier           = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
}
