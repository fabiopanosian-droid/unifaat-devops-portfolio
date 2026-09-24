locals {
  resource_prefix = "${var.ra}-technova"

  common_tags = {
    Project    = var.project_name
    ManagedBy  = "Terraform"
    Aluno      = var.aluno
    RA         = var.ra
    Disciplina = "DevOps - UniFAAT 2026-2"
    Aula       = "03"
  }

  users = {
    juliana = "${var.ra}-juliana-dev"
    rafael  = "${var.ra}-rafael-platform"
    lucas   = "${var.ra}-lucas-intern"
  }
}

resource "aws_iam_group" "developers" {
  name = "${local.resource_prefix}-developers"
  path = "/technova/"
}

resource "aws_iam_group" "platform_eng" {
  name = "${local.resource_prefix}-platform-eng"
  path = "/technova/"
}

resource "aws_iam_user" "users" {
  for_each = local.users

  name = each.value
  path = "/technova/"
  tags = local.common_tags
}

resource "aws_iam_group_membership" "developers" {
  name = "${local.resource_prefix}-developers-membership"

  users = [
    aws_iam_user.users["juliana"].name,
    aws_iam_user.users["rafael"].name,
    aws_iam_user.users["lucas"].name
  ]

  group = aws_iam_group.developers.name
}

resource "aws_iam_group_membership" "platform_eng" {
  name = "${local.resource_prefix}-platform-membership"

  users = [
    aws_iam_user.users["rafael"].name
  ]

  group = aws_iam_group.platform_eng.name
}