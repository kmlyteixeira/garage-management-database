output "os_db_instance_identifier" {
  description = "OS Service RDS instance identifier."
  value       = aws_db_instance.os.identifier
}

output "os_db_endpoint" {
  description = "OS Service RDS endpoint hostname."
  value       = aws_db_instance.os.address
}

output "os_db_name" {
  description = "OS Service database name."
  value       = aws_db_instance.os.db_name
}

output "billing_db_instance_identifier" {
  description = "Billing Service RDS instance identifier."
  value       = aws_db_instance.billing.identifier
}

output "billing_db_name" {
  description = "Billing Service database name."
  value       = aws_db_instance.billing.db_name
}

output "billing_db_endpoint" {
  description = "Billing Service RDS endpoint hostname."
  value       = aws_db_instance.billing.address
}

output "postgres_port" {
  description = "PostgreSQL port used by OS and Billing."
  value       = 5432
}

output "execution_db_cluster_identifier" {
  description = "Execution Service DocumentDB cluster identifier."
  value       = aws_docdb_cluster.execution.cluster_identifier
}

output "execution_db_endpoint" {
  description = "Execution Service DocumentDB writer endpoint."
  value       = aws_docdb_cluster.execution.endpoint
}

output "execution_db_reader_endpoint" {
  description = "Execution Service DocumentDB reader endpoint."
  value       = aws_docdb_cluster.execution.reader_endpoint
}

output "execution_db_port" {
  description = "DocumentDB port."
  value       = aws_docdb_cluster.execution.port
}

output "database_security_group_id" {
  description = "Security group attached to all service databases."
  value       = aws_security_group.databases.id
}

output "database_parameter_prefix" {
  value = "/${var.project_name}/${var.environment}/database"
}
