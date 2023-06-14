module "iam_root_access_key_check" {
  source = "../modules/rules"

  rule_name                        = "iam-root-access-key-check"
  rule_description                 = "Checks whether the root user access key is available. The rule is compliant if the user access key does not exist."
  rule_maximum_execution_frequency = "TwentyFour_Hours"
  rule_source_identifier           = "IAM_ROOT_ACCESS_KEY_CHECK"
}
