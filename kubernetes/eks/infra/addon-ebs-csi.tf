data "aws_iam_policy_document" "assume_role_policy_ebs_csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "ebs_csi" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_ebs_csi.json
  name_prefix        = "${var.cluster_name}-ebs-csi"
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi.name
}

resource "aws_eks_addon" "ebs_csi" {
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.addon_version_ebs_csi
  cluster_name             = var.cluster_name
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.ebs_csi.arn

  depends_on = [module.eks]
}
