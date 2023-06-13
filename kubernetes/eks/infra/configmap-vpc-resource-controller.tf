resource "kubernetes_config_map" "vpc-resource-controller" {

  metadata {
    name      = "amazon-vpc-cni"
    namespace = "kube-system"
  }

  data = {
    enable-windows-ipam : "true"
  }

  depends_on = [module.eks]

}
