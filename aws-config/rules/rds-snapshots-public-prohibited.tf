module "rds_snapshots_public_prohibited" {
  source = "../modules/rules"

  rule_name                        = "rds-snapshots-public-prohibited"
  rule_description                 = "Checks if Amazon Relational Database Service (Amazon RDS) snapshots are public. The rule is non-compliant if any existing and new Amazon RDS snapshots are public."
  rule_compliance_resource_types   = ["AWS::RDS::DBSnapshot"]
  rule_source_identifier           = "RDS_SNAPSHOTS_PUBLIC_PROHIBITED"
}
