module "cloud_trail_encryption_enabled" {
  source = "../modules/rules"

  rule_name                        = "cloud-trail-encryption-enabled"
  rule_description                 = "Checks whether AWS CloudTrail is configured to use the server side encryption (SSE) AWS Key Management Service (AWS KMS) customer master key (CMK) encryption. The rule is compliant if the KmsKeyId is defined."
  rule_maximum_execution_frequency = "TwentyFour_Hours"
  rule_compliance_resource_types   = ["AWS::ACM::Certificate"]
  rule_source_identifier           = "ACM_CERTIFICATE_EXPIRATION_CHECK"
}
