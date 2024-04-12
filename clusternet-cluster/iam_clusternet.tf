data "aws_iam_policy_document" "clusternet_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }

  #   statement {
  #     actions = ["sts:AssumeRole"]
  #     effect  = "Allow"
  #     principals {
  #       identifiers = [
  #         format("arn:aws:iam::%s:role/%s-clusternet", data.aws_caller_identity.current.id, var.cluster_name)
  #       ]
  #       type = "AWS"
  #     }
  #   }

}

resource "aws_iam_role" "clusternet" {
  assume_role_policy = data.aws_iam_policy_document.clusternet_assume_role.json
  name               = format("%s-clusternet", var.cluster_name)
}

data "aws_iam_policy_document" "clusternet_policy" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "*"
    ]

  }

}

resource "aws_iam_policy" "clusternet_policy" {
  name        = format("%s-clusternet-policy", var.cluster_name)
  path        = "/"
  description = var.cluster_name

  policy = data.aws_iam_policy_document.clusternet_policy.json
}

resource "aws_iam_policy_attachment" "clusternet_policy" {
  name = "clusternet_policy"

  roles = [aws_iam_role.clusternet.name]

  policy_arn = aws_iam_policy.clusternet_policy.arn
}