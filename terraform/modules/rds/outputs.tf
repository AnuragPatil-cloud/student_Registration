output "db_endpoint" {
  description = "RDS connection endpoint"
  value       = aws_db_instance.this.endpoint
  sensitive   = true
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "db_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.identifier
}

output "db_security_group_id" {
  description = "Security group ID for the RDS instance"
  value       = aws_security_group.rds.id
}
