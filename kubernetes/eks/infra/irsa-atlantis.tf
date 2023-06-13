# Deprecating since we're now using spacelift.
data "aws_iam_policy_document" "assume_role_policy_atlantis" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:atlantis:atlantis"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}


data "aws_iam_policy_document" "atlantis" {
  statement {
    effect = "Allow"

    actions = ["*"]

    resources = ["*"]
  }
}

resource "aws_iam_role" "atlantis" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_atlantis.json
  name_prefix        = "${var.cluster_name}-atlantis"
}

resource "aws_iam_role_policy" "atlantis" {
  policy = data.aws_iam_policy_document.atlantis.json
  role   = aws_iam_role.atlantis.id
}

resource "aws_ssm_parameter" "atlantis_role" {
  name  = "/eks/${var.cluster_name}/iamroles/atlantis"
  type  = "String"
  value = aws_iam_role.atlantis.arn
}
