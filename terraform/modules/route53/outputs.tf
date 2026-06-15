output "public_zone_id" {
  description = "Public hosted zone ID"
  value       = aws_route53_zone.public.zone_id
}

output "public_zone_name_servers" {
  description = "Name servers for the public hosted zone"
  value       = aws_route53_zone.public.name_servers
}

output "private_zone_id" {
  description = "Private hosted zone ID (if created)"
  value       = var.create_private_zone ? aws_route53_zone.private[0].zone_id : null
}

output "health_check_id" {
  description = "Route53 health check ID"
  value       = aws_route53_health_check.root.id
}
