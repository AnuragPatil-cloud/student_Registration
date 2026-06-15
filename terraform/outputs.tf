# ── VPC ───────────────────────────────────────────────────────────────────────
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs of the database subnets"
  value       = module.vpc.database_subnet_ids
}

# ── EKS ───────────────────────────────────────────────────────────────────────
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "eks_oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider (for IRSA)"
  value       = module.eks.oidc_provider_arn
}

# ── RDS ───────────────────────────────────────────────────────────────────────
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.db_port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = module.rds.db_name
}

# ── IAM ───────────────────────────────────────────────────────────────────────
output "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  value       = module.iam.eks_node_role_arn
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  value       = module.iam.eks_cluster_role_arn
}

# ── Route53 ───────────────────────────────────────────────────────────────────
output "public_zone_id" {
  description = "Route53 public hosted zone ID"
  value       = module.route53.public_zone_id
}

output "public_zone_name_servers" {
  description = "Name servers for the public hosted zone"
  value       = module.route53.public_zone_name_servers
}
