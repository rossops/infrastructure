module "restricted_common_ports_windows_fileshare" {
  source = "../modules/rules"

  rule_name                        = "restricted-common-ports-windows-fileshare"
  rule_description                 = "Checks whether security groups that are in use disallow unrestricted incoming TCP traffic to the specified ports."
  rule_input_parameters            = "{\"blockedPort1\":\"445\",\"blockedPort2\":\"139\"}"
  rule_compliance_resource_types   = ["AWS::EC2::SecurityGroup"]
  rule_source_identifier           = "RESTRICTED_INCOMING_TRAFFIC"
}
