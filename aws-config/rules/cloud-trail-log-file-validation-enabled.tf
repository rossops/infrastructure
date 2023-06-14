module "cloud_trail_log_file_validation_enabled" {
  source = "../modules/rules"

  rule_name                        = "cloud-trail-log-file-validation-enabled"
  rule_description                 = "Checks whether AWS CloudTrail creates a signed digest file with logs. AWS recommends that the file validation must be enabled on all trails. The rule is noncompliant if the validation is not enabled."
  rule_maximum_execution_frequency = "TwentyFour_Hours"
  rule_source_identifier           = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"
}
