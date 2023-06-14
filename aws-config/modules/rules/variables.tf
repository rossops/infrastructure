variable "rule_name" {}
variable "rule_description" {}
variable "rule_input_parameters" {
	type 		= "string"
	default = "{}"
}

variable "rule_maximum_execution_frequency" {
	type 		= "string"
	default = null
}

variable "rule_compliance_resource_types" {
  type    = "list"
	default = null
}

variable "rule_owner" {
	default = "AWS"
}

variable "rule_source_identifier" {}
