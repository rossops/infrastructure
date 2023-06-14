module "rds_instance_public_access_check" {
  source = "../modules/rules"

  rule_name                        = "rds-instance-public-access-check"
  rule_description                 = "Checks whether the Amazon Relational Database Service (RDS) instances are not publicly accessible. The rule is non-compliant if the publiclyAccessible field is true in the instance configuration item."
  rule_compliance_resource_types   = ["AWS::RDS::DBInstance"]
  rule_source_identifier           = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
}
