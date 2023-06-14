module "restricted_common_ports_management" {
  source = "../modules/rules"

  rule_name                        = "restricted-common-ports-management"
  rule_description                 = "Checks whether security groups that are in use disallow unrestricted incoming TCP traffic to the specified ports."
  rule_input_parameters            = "{\"blockedPort1\":\"22\",\"blockedPort2\":\"3389\",\"blockedPort3\":\"5986\",\"blockedPort4\":\"5985\",\"blockedPort5\":\"23\"}"

  rule_compliance_resource_types = [
		"AWS::EC2::SecurityGroup",
    "AWS::RDS::DBSecurityGroup",
    "AWS::Redshift::ClusterSecurityGroup"
	]

  rule_source_identifier           = "RESTRICTED_INCOMING_TRAFFIC"
}
