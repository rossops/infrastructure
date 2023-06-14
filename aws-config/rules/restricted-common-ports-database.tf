module "restricted_common_ports_database" {
  source = "../modules/rules"

  rule_name                        = "restricted-common-ports-database"
  rule_description                 = "Checks whether security groups that are in use disallow unrestricted incoming TCP traffic to the specified ports."
  rule_input_parameters            = "{\"blockedPort1\":\"1433\",\"blockedPort2\":\"3306\",\"blockedPort3\":\"5432\",\"blockedPort4\":\"9200\",\"blockedPort5\":\"9300\"}"

  rule_compliance_resource_types = [
		"AWS::EC2::SecurityGroup",
    "AWS::RDS::DBSecurityGroup",
    "AWS::Redshift::ClusterSecurityGroup"
	]

  rule_source_identifier           = "RESTRICTED_INCOMING_TRAFFIC"
}
