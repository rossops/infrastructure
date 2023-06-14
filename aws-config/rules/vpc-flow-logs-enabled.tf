module "vpc_flow_logs_enabled" {
  source = "../modules/rules"

  rule_name                        = "vpc-flow-logs-enabled"
  rule_description                 = "Checks whether Amazon Virtual Private Cloud flow logs are found and enabled for Amazon VPC."
  rule_maximum_execution_frequency = "TwentyFour_Hours"
  rule_source_identifier           = "VPC_FLOW_LOGS_ENABLED"
}
