variable "addon_version_coredns" {
  default     = "v1.8.7-eksbuild.3"
  description = "available versions can be found with `aws eks describe-addon-versions --addon-name coredns | grep -i addonversion`"
  type        = string
}

variable "addon_version_ebs_csi" {
  default     = "v1.11.5-eksbuild.2"
  description = "available versions can be found with `aws eks describe-addon-versions --addon-name aws-ebs-csi-driver | grep -i addonversion`"
  type        = string
}

variable "addon_version_kube_proxy" {
  default     = "v1.23.8-eksbuild.2"
  description = "available versions can be found with `aws eks describe-addon-versions --addon-name kube-proxy | grep -i addonversion`"
  type        = string
}

variable "addon_version_vpc_cni" {
  default     = "v1.12.0-eksbuild.1"
  description = "available versions can be found with `aws eks describe-addon-versions --addon-name vpc-cni | grep -i addonversion`"
  type        = string
}

variable "aws_region" {
  type = string
}

variable "cluster_enabled_log_types" {
  default     = ["api", "audit"]
  description = "list of control plane logs to enable. See https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
  type        = list(string)
}

variable "cluster_log_retention_in_days" {
  default = 30
  type    = number
}

variable "cluster_name" {
  type = string
}

variable "cluster_endpoint_public_access" {
  default = true
  type    = bool
}

variable "cluster_private_access_cidrs" {
  default = ["10.0.0.0/8"]
  type    = list(string)
}

variable "cluster_subnets" {
  description = "subnets for nodes, LBs, and control plane"
  type        = list(string)
}

variable "cluster_version" {
  default = "1.23"
  type    = string
}

variable "dns_dd" {
  default     = false
  description = "whether to enable external-dns cross-account access to downdetective"
  type        = bool
}

variable "eks_managed_node_groups" {
  description = "See https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/node_groups"
  type        = any
}

variable "eks_managed_node_group_defaults" {
  description = "See https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/node_groups"
  type        = any
}

variable "environment" {
  description = "used in tagging, such as intg, dev, stage, prod"
  type        = string
}

variable "iam_role_name" {
  default     = null
  description = "cluster iam role name"
  type        = string
}

variable "iam_role_downdetective" {
  default     = "arn:aws:iam::xxxxxxxxxxxxxx:role/DDAccountAccessRole"
  description = "IAM Role for creating cross-account resources"
  type        = string
}

variable "map_roles" {
  default = [
    {
      rolearn  = "arn:aws:iam::xxxxxxxxxxxx:role/eksadmin"
      username = "eksadmin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::xxxxxxxxxxxx:role/eksdevs"
      username = "eksdevs"
      groups   = ["system:masters"]
    }
  ]
  description = "IAM roles to add to the aws-auth config map"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "map_users" {
  default = [
    {
      userarn  = "arn:aws:iam::xxxxxxxxxxxx:user/jenkinsprod"
      username = "jenkinsprod"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::xxxxxxxxxxxx:user/jenkinsdev"
      username = "jenkinsdev"
      groups   = ["system:masters"]
    }
  ]
  description = "IAM users to add to the aws-auth config map"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "role_github_runner_downdetective_ns" {
  default     = []
  description = "namespaces to allow access to"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}
