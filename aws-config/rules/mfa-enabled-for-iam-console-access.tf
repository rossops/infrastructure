module "mfa_enabled_for_iam_console_access" {
  source = "../modules/rules"

  rule_name                        = "mfa-enabled-for-iam-console-access"
  rule_description                 = "Checks whether AWS Multi-Factor Authentication (MFA) is enabled for all AWS Identity and Access Management (IAM) users that use a console password. The rule is compliant if MFA is enabled."
  rule_maximum_execution_frequency = "Three_Hours"
  rule_source_identifier           = "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"
}
