module "db_instance_backup_enabled" {
  source = "../modules/rules"

  rule_name                        = "db-instance-backup-enabled"
  rule_description                 = "Checks whether RDS DB instances have backups enabled. Optionally, the rule checks the backup retention period and the backup window."
  rule_input_parameters            = "{\"checkReadReplicas\":\"false\"}"
  rule_compliance_resource_types   = ["AWS::RDS::DBInstance"]
  rule_source_identifier           = "DB_INSTANCE_BACKUP_ENABLED"
}
