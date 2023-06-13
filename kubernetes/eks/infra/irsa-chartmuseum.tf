data "aws_iam_policy_document" "assume_role_policy_chartmuseum" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:chartmuseum:chartmuseum-chartmuseum"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}


data "aws_iam_policy_document" "chartmuseum" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = ["arn:aws:s3:::kubecharts/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = ["arn:aws:s3:::kubecharts"]
  }
}

resource "aws_iam_role" "chartmuseum" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_chartmuseum.json
  name_prefix        = "${var.cluster_name}-chartmuseum"
}

resource "aws_iam_role_policy" "chartmuseum" {
  policy = data.aws_iam_policy_document.chartmuseum.json
  role   = aws_iam_role.chartmuseum.id
}

resource "aws_ssm_parameter" "chartmuseum_role" {
  name  = "/eks/${var.cluster_name}/iamroles/chartmuseum"
  type  = "String"
  value = aws_iam_role.chartmuseum.arn
}

