output "user_names" {
  description = "Usuários IAM criados"
  value       = [for user in aws_iam_user.users : user.name]
}

output "group_names" {
  description = "Grupos IAM criados"
  value = [
    aws_iam_group.developers.name,
    aws_iam_group.platform_eng.name
  ]
}

output "policy_arns" {
  description = "ARNs das policies customizadas"
  value = {
    s3_read          = aws_iam_policy.s3_read.arn
    ec2_s3_full      = aws_iam_policy.ec2_s3_full.arn
    deny_destructive = aws_iam_policy.deny_destructive.arn
    ec2_s3_access    = aws_iam_policy.ec2_s3_access.arn
  }
}

output "role_arn" {
  description = "ARN da role da EC2"
  value       = aws_iam_role.ec2_role.arn
}

output "instance_profile_name" {
  description = "Nome do instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}