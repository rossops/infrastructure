resource "aws_config_config_rule" "config_rule" {
  name                        = "${var.rule_name}"
  description                 = "${var.rule_description}"
  input_parameters            = "${var.rule_input_parameters}"
  maximum_execution_frequency = "${var.rule_maximum_execution_frequency}"

  scope {
    compliance_resource_types = "${var.rule_compliance_resource_types}"
  }

  source {
    owner             = "${var.rule_owner}"
    source_identifier = "${var.rule_source_identifier}"
  }
}
