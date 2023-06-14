module "dynamodb_table_encryption_enabled" {
  source = "../modules/rules"

  rule_name                        = "dynamodb-table-encryption-enabled"
  rule_description                 = "Checks whether the Amazon DynamoDB tables are encrypted and checks their status. The rule is compliant if the status is enabled or enabling."
  rule_compliance_resource_types   = ["AWS::DynamoDB::Table"]
  rule_source_identifier           = "DYNAMODB_TABLE_ENCRYPTION_ENABLED"
}
