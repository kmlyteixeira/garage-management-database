variable "project_name" {
  description = "Stable prefix for database resources."
  type        = string
  default     = "garage-management"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "homologacao", "producao"], var.environment)
    error_message = "environment must be development, homologacao or producao."
  }
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC that hosts the database."
  type        = string
}

variable "private_subnet_ids" {
  description = "At least two private subnet IDs in different availability zones."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnet IDs are required for the database subnet group."
  }
}

variable "api_security_group_id" {
  description = "Security group allowed to connect to PostgreSQL."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "GarageManagement"
}

variable "db_username" {
  description = "Master username. Prefer Secrets Manager-managed credentials in production."
  type        = string
  default     = "garage_user"
}

variable "db_password" {
  description = "Master password supplied through an external secret or CI variable."
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable synchronous standby in another availability zone."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be between 1 and 35 days."
  }
}

variable "deletion_protection" {
  description = "Prevent accidental database deletion."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
