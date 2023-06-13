locals {
  tags = {
    environment         = var.environment
    infrastructure_repo = "infrastructure"
    product             = "DevOps"
    project_repo        = "infrastructure"
    region              = var.aws_region
    role                = "kubernetes"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  # required
  cluster_name = var.cluster_name
  subnet_ids   = var.cluster_subnets
  vpc_id       = var.vpc_id

  # optional
  aws_auth_node_iam_role_arns_windows    = [aws_iam_role.windows_worker.arn]
  aws_auth_roles                         = var.map_roles
  aws_auth_users                         = var.map_users
  cluster_encryption_config              = {}
  cluster_enabled_log_types              = var.cluster_enabled_log_types
  cluster_endpoint_private_access        = true
  cluster_endpoint_public_access         = var.cluster_endpoint_public_access
  cloudwatch_log_group_retention_in_days = var.cluster_log_retention_in_days
  cluster_version                        = var.cluster_version
  eks_managed_node_groups                = var.eks_managed_node_groups
  eks_managed_node_group_defaults        = var.eks_managed_node_group_defaults
  enable_irsa                            = true
  manage_aws_auth_configmap              = true
  tags                                   = local.tags

  # useful for module version 18.x upgrade
  cluster_security_group_description = "EKS cluster security group."
  cluster_security_group_name        = var.cluster_name
  iam_role_name                      = var.iam_role_name
  iam_role_use_name_prefix           = false
  prefix_separator                   = ""

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

  # prometheus-adapter
    ingress_cluster_6443_webhook = {
      description                   = "Cluster API to node 6443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 6443
      to_port                       = 6443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name       = var.cluster_name
  # depends_on needed for new clusters, but breaks existing clusters
  # module.eks.cluster_endpoint and cluster_arn appear to return empty data
  # at least during the upgrade to module 18.x/19.x
  #depends_on = [module.eks.cluster_arn]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = var.cluster_name
  # depends_on needed for new clusters, but breaks existing clusters
  # module.eks.cluster_endpoint and cluster_arn appear to return empty data
  # at least during the upgrade to module 18.x/19.x
  #depends_on = [module.eks.cluster_arn]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
