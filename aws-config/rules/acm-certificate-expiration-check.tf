module "acm_certificate_expiration_check" {
  source = "../modules/rules"

  rule_name                        = "acm-certificate-expiration-check"
  rule_description                 = "Checks whether ACM Certificates in your account are marked for expiration within the specified number of days. Certificates provided by ACM are automatically renewed. ACM does not automatically renew certificates that you import."
  rule_input_parameters            = "{\"daysToExpiration\":\"30\"}"
  rule_maximum_execution_frequency = "One_Hour"
  rule_compliance_resource_types   = ["AWS::ACM::Certificate"]
  rule_source_identifier           = "ACM_CERTIFICATE_EXPIRATION_CHECK"
}
