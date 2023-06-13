resource "aws_eks_addon" "kube_proxy" {
  addon_name        = "kube-proxy"
  addon_version     = var.addon_version_kube_proxy
  cluster_name      = var.cluster_name
  resolve_conflicts = "OVERWRITE"

  depends_on = [module.eks]
}
