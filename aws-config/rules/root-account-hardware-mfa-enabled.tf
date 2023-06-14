module "root_account_hardware_mfa_enabled" {
  source = "../modules/rules"

  rule_name                        = "root-account-hardware-mfa-enabled"
  rule_description                 = "Checks whether your AWS account is enabled to use multi-factor authentication (MFA) hardware device to sign in with root credentials."
  rule_maximum_execution_frequency = "TwentyFour_Hours"
  rule_source_identifier           = "ROOT_ACCOUNT_HARDWARE_MFA_ENABLED"
}
