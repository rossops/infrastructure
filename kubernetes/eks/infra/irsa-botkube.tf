data "aws_iam_policy_document" "assume_role_policy_botkube" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:botkube:botkube"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}


data "aws_iam_policy_document" "botkube" {
  statement {
    effect = "Allow"

    actions = ["*"]

    resources = ["*"]
  }
}

resource "aws_iam_role" "botkube" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_botkube.json
  name_prefix        = "${var.cluster_name}-botkube"
}

resource "aws_iam_role_policy" "botkube" {
  policy = data.aws_iam_policy_document.botkube.json
  role   = aws_iam_role.botkube.id
}

resource "aws_ssm_parameter" "botkube_role" {
  name  = "/eks/${var.cluster_name}/iamroles/botkube"
  type  = "String"
  value = aws_iam_role.botkube.arn
}
