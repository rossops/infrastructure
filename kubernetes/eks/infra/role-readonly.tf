resource "kubernetes_cluster_role" "readonly" {
  metadata {
    name = "custom-readonly"
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "readonly" {
  metadata {
    name = "custom-readonly"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "custom-readonly"
  }
  subject {
    kind      = "Group"
    name      = "custom-readonly"
    api_group = "rbac.authorization.k8s.io"
  }
}
