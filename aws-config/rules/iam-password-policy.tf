module "iam_password_policy" {
  source = "../modules/rules"

  rule_name                        = "iam-password-policy"
  rule_description                 = "Checks whether the account password policy for IAM users meets the specified requirements."
  rule_input_parameters            = "{\"RequireUppercaseCharacters\":\"true\",\"RequireLowercaseCharacters\":\"true\",\"RequireSymbols\":\"true\",\"RequireNumbers\":\"true\",\"MinimumPasswordLength\":\"12\",\"PasswordReusePrevention\":\"2\",\"MaxPasswordAge\":\"120\"}"
  rule_maximum_execution_frequency = "One_Hour"
  rule_source_identifier           = "IAM_PASSWORD_POLICY"
}
