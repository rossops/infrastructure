module "redshift_cluster_configuration_check" {
  source = "../modules/rules"

  rule_name                        = "redshift-cluster-configuration-check"
  rule_description                 = "Checks whether Amazon Redshift clusters have the specified settings."
  rule_input_parameters            = "{\"clusterDbEncrypted\":\"true\",\"loggingEnabled\":\"true\",\"nodeTypes\":\"dc2.8xlarge\"}"
  rule_compliance_resource_types   = ["AWS::Redshift::Cluster"]
  rule_source_identifier           = "REDSHIFT_CLUSTER_CONFIGURATION_CHECK"
}
