output "db_instance_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.postgres.identifier
}

output "db_endpoint" {
  description = "RDS endpoint hostname."
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "RDS PostgreSQL port."
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Application database name."
  value       = aws_db_instance.postgres.db_name
}

output "db_security_group_id" {
  description = "Security group attached to RDS."
  value       = aws_security_group.postgres.id
}
