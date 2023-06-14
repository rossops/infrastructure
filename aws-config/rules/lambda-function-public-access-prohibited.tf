module "lambda_function_public_access_prohibited" {
  source = "../modules/rules"

  rule_name                        = "lambda-function-public-access-prohibited"
  rule_description                 = "Checks whether the Lambda function policy prohibits public access. The rule is NON_COMPLIANT if the Lambda function policy allows public access."
  rule_compliance_resource_types   = ["AWS::Lambda::Function"]
  rule_source_identifier           = "LAMBDA_FUNCTION_PUBLIC_ACCESS_PROHIBITED"
}
