data "aws_iam_policy_document" "s3_read" {
  statement {
    sid    = "ListTechnovaBuckets"
    effect = "Allow"

    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::technova-*"]
  }

  statement {
    sid    = "ReadTechnovaObjects"
    effect = "Allow"

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::technova-*/*"]
  }
}

resource "aws_iam_policy" "s3_read" {
  name        = "${local.resource_prefix}-s3-read"
  description = "Leitura controlada nos buckets TechNova"
  policy      = data.aws_iam_policy_document.s3_read.json
  tags        = local.common_tags
}

resource "aws_iam_group_policy_attachment" "developers_s3_read" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.s3_read.arn
}

data "aws_iam_policy_document" "ec2_s3_full" {
  statement {
    sid    = "DescribeEc2"
    effect = "Allow"

    actions   = ["ec2:DescribeInstances", "ec2:DescribeTags", "ec2:DescribeVolumes"]
    resources = ["*"]
  }

  statement {
    sid    = "StartStopTaggedInstances"
    effect = "Allow"

    actions   = ["ec2:StartInstances", "ec2:StopInstances"]
    resources = ["arn:aws:ec2:*:*:instance/*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    sid    = "ReadWriteTechnovaS3"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::technova-*",
      "arn:aws:s3:::technova-*/*"
    ]
  }
}

resource "aws_iam_policy" "ec2_s3_full" {
  name        = "${local.resource_prefix}-ec2-s3-full"
  description = "Gerenciamento controlado de EC2 e S3"
  policy      = data.aws_iam_policy_document.ec2_s3_full.json
  tags        = local.common_tags
}

resource "aws_iam_group_policy_attachment" "platform_ec2_s3_full" {
  group      = aws_iam_group.platform_eng.name
  policy_arn = aws_iam_policy.ec2_s3_full.arn
}

data "aws_iam_policy_document" "deny_destructive" {
  statement {
    sid    = "DenyDestructiveActions"
    effect = "Deny"

    actions = [
      "s3:Delete*",
      "ec2:TerminateInstances"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "deny_destructive" {
  name        = "${local.resource_prefix}-deny-destructive"
  description = "Impede operacoes destrutivas"
  policy      = data.aws_iam_policy_document.deny_destructive.json
  tags        = local.common_tags
}

resource "aws_iam_group_policy_attachment" "developers_deny_destructive" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.deny_destructive.arn
}