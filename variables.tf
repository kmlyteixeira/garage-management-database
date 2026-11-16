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
  description = "Legacy/API security group allowed during migration."
  type        = string
}

variable "workload_security_group_ids" {
  description = "EKS/node security groups allowed to access service databases."
  type        = list(string)
  default     = []
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "os_db_name" {
  description = "OS Service PostgreSQL database name."
  type        = string
  default     = "os_service"
}

variable "os_db_username" {
  description = "OS Service PostgreSQL master username."
  type        = string
  default     = "os_service"
}

variable "os_db_password" {
  description = "OS Service PostgreSQL password supplied through an external secret or CI variable."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.os_db_password) >= 16
    error_message = "os_db_password must contain at least 16 characters."
  }
}

variable "billing_db_name" {
  description = "Billing Service PostgreSQL database name."
  type        = string
  default     = "billing_service"
}

variable "billing_db_username" {
  description = "Billing Service PostgreSQL master username."
  type        = string
  default     = "billing_service"
}

variable "billing_db_password" {
  description = "Billing Service PostgreSQL password."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.billing_db_password) >= 16
    error_message = "billing_db_password must contain at least 16 characters."
  }
}

variable "execution_mongodb_connection_string" {
  description = "MongoDB connection string for the MongoDB service running in EKS."
  type        = string
  default     = "mongodb://mongodb.garage-microservices.svc.cluster.local:27017/execution?retryWrites=false"
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
