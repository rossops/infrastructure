module "iam_group_has_users_check" {
  source = "../modules/rules"

  rule_name                        = "iam-group-has-users-check"
  rule_description                 = "Checks whether IAM groups have at least one IAM user."
  rule_compliance_resource_types   = ["AWS::IAM::Group"]
  rule_source_identifier           = "IAM_GROUP_HAS_USERS_CHECK"
}
