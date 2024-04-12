data "aws_iam_policy_document" "clusternet_deployer_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = [
        aws_iam_role.clusternet.arn
      ]
      type = "AWS"
    }
  }
}

resource "aws_iam_role" "clusternet_deployer" {
  assume_role_policy = data.aws_iam_policy_document.clusternet_deployer_assume_role.json
  name               = format("%s-clusternet-deployer", var.cluster_name)
}
