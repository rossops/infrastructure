resource "aws_eks_addon" "coredns" {
  addon_name        = "coredns"
  addon_version     = var.addon_version_coredns
  cluster_name      = var.cluster_name
  resolve_conflicts = "OVERWRITE"

  depends_on = [module.eks]
}
