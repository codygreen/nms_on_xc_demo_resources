
data "aws_iam_policy_document" "nms_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "nms_role" {
  name               = format("%s-nms-role", local.owner_name_safe)
  assume_role_policy = data.aws_iam_policy_document.nms_role.json

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "nms_profile" {
  name = format("%s-nms-profile", local.owner_name_safe)
  role = aws_iam_role.nms_role.name
}

data "aws_iam_policy_document" "nms_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.nginx-repo-crt.arn,
      aws_secretsmanager_secret.nginx-repo-key.arn,
    ]
  }
}

resource "aws_iam_role_policy" "nms_policy" {
  name   = format("%s-nms-policy", local.owner_name_safe)
  role   = aws_iam_role.nms_role.id
  policy = data.aws_iam_policy_document.nms_policy.json
}
