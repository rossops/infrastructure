data "aws_iam_policy_document" "assume_role_policy_keda" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:keda:keda-operator"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}


data "aws_iam_policy_document" "keda" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "kinesis:DescribeStreamSummary",
      "sqs:GetQueueAttributes"
    ]

    resources = ["*"]
  }

}

resource "aws_iam_role" "keda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_keda.json
  name_prefix        = "${var.cluster_name}-keda"
}

resource "aws_iam_role_policy" "keda" {
  policy = data.aws_iam_policy_document.keda.json
  role   = aws_iam_role.keda.id
}

resource "aws_ssm_parameter" "keda_role" {
  name  = "/eks/${var.cluster_name}/iamroles/keda"
  type  = "String"
  value = aws_iam_role.keda.arn
}
