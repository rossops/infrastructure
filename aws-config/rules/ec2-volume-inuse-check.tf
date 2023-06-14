module "ec2_volume_inuse_check" {
  source = "../modules/rules"

  rule_name                        = "ec2-volume-inuse-check"
  rule_description                 = "Checks whether EBS volumes are attached to EC2 instances. Optionally checks if EBS volumes are marked for deletion when an instance is terminated."
  rule_compliance_resource_types   = ["AWS::EC2::Volume"]
  rule_source_identifier           = "EC2_VOLUME_INUSE_CHECK"
}
