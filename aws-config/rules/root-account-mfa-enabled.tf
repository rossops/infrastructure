module "root_account_mfa_enabled" {
  source = "../modules/rules"

  rule_name                        = "root-account-mfa-enabled"
  rule_description                 = "Checks whether the root user of your AWS account requires multi-factor authentication for console sign-in."
  rule_maximum_execution_frequency = "One_Hour"
  rule_source_identifier           = "ROOT_ACCOUNT_MFA_ENABLED"
}
