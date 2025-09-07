variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}