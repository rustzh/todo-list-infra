# AWS Region
region = "ap-northeast-3"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["ap-northeast-3a", "ap-northeast-3c"]
public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

# EKS Configuration
cluster_name    = "nyeong-eks"
cluster_version = "1.32"

# Node Group Configuration
node_group_config = {
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  min_size       = 1
  max_size       = 4
  desired_size   = 2
}

# Domain Configuration
domain_name = "div4u.com"

# Tags
tags = {
  Environment = "production"
  Project     = "div4u"
  ManagedBy   = "terraform"
}