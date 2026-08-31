# ============================================
# VPC Outputs
# ============================================

output "vpc_id" {
  description = "Student Registration VPC ID"

  value = aws_vpc.main.id
}


output "public_subnet_ids" {
  description = "Public subnet IDs"

  value = aws_subnet.public[*].id
}


output "private_subnet_ids" {
  description = "Private subnet IDs"

  value = aws_subnet.private[*].id
}


# ============================================
# EKS Outputs
# ============================================

output "eks_cluster_name" {
  description = "EKS cluster name"

  value = aws_eks_cluster.main.name
}


output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"

  value = aws_eks_cluster.main.endpoint
}


# ============================================
# RDS Outputs
# ============================================

output "rds_endpoint" {
  description = "RDS endpoint"

  value = aws_db_instance.main.endpoint
}


output "rds_address" {
  description = "RDS hostname"

  value = aws_db_instance.main.address
}


output "rds_port" {
  description = "RDS port"

  value = aws_db_instance.main.port
}