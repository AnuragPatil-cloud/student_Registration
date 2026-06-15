output "vpc_id" {
  value = module.infrastructure.vpc_id
}

output "eks_cluster_name" {
  value = module.infrastructure.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value     = module.infrastructure.eks_cluster_endpoint
  sensitive = true
}

output "rds_endpoint" {
  value     = module.infrastructure.rds_endpoint
  sensitive = true
}

output "public_zone_name_servers" {
  description = "Delegate these NS records to your registrar"
  value       = module.infrastructure.public_zone_name_servers
}
