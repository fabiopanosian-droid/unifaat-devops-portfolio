data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid    = "AllowEc2AssumeRole"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${local.resource_prefix}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "ec2_s3_access" {
  statement {
    sid    = "ListApplicationBuckets"
    effect = "Allow"

    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::technova-app-data-*"]
  }

  statement {
    sid    = "ReadWriteApplicationObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = ["arn:aws:s3:::technova-app-data-*/*"]
  }
}

resource "aws_iam_policy" "ec2_s3_access" {
  name        = "${local.resource_prefix}-ec2-s3-access"
  description = "Acesso da EC2 aos dados da aplicacao"
  policy      = data.aws_iam_policy_document.ec2_s3_access.json
  tags        = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_access.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.resource_prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name
  tags = local.common_tags
}