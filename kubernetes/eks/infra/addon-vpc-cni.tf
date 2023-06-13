data "aws_iam_policy_document" "assume_role_policy_vpc_cni" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "vpc_cni" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_vpc_cni.json
  name_prefix        = "${var.cluster_name}-vpc-cni"
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni.name
}

resource "aws_eks_addon" "vpc_cni" {
  addon_name               = "vpc-cni"
  addon_version            = var.addon_version_vpc_cni
  cluster_name             = var.cluster_name
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.vpc_cni.arn

  depends_on = [module.eks]
}
