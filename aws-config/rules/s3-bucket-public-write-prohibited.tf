module "s3_bucket_public_write_prohibited" {
  source = "../modules/rules"

  rule_name                        = "s3-bucket-public-write-prohibited"
  rule_description                 = "Checks that your S3 buckets do not allow public write access. If an S3 bucket policy or bucket ACL allows public write access, the bucket is noncompliant."
  rule_compliance_resource_types   = ["AWS::S3::Bucket"]
  rule_source_identifier           = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
}
