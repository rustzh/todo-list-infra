output "ebs_csi_driver_role_arn" {
  description = "EBS CSI Driver IAM role ARN"
  value       = aws_iam_role.ebs_csi_driver.arn
}

output "aws_load_balancer_controller_role_arn" {
  description = "AWS Load Balancer Controller IAM role ARN"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "external_dns_role_arn" {
  description = "External DNS IAM role ARN"
  value       = aws_iam_role.external_dns.arn
}