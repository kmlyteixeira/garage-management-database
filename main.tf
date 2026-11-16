locals {
  name = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Component   = "database"
  })

  allowed_workload_security_groups = distinct(concat(
    [var.api_security_group_id],
    var.workload_security_group_ids
  ))
}

resource "terraform_data" "production_requirements" {
  input = var.environment

  lifecycle {
    precondition {
      condition     = var.environment != "producao" || length(var.workload_security_group_ids) > 0
      error_message = "Production requires at least one EKS workload security group."
    }
    precondition {
      condition     = var.environment != "producao" || var.multi_az
      error_message = "Production requires multi_az=true for PostgreSQL."
    }
  }
}

resource "aws_db_subnet_group" "postgres" {
  name       = "${local.name}-postgres-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = local.common_tags
}

resource "aws_security_group" "databases" {
  name        = "${local.name}-databases"
  description = "Private access for Garage Management databases"
  vpc_id      = var.vpc_id

  ingress {
    description     = "OS and Billing PostgreSQL from approved workloads"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = local.allowed_workload_security_groups
  }

  ingress {
    description     = "Execution MongoDB traffic from approved workloads"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = local.allowed_workload_security_groups
  }

  egress {
    description = "Database response traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_db_instance" "os" {
  identifier                = "${local.name}-os"
  engine                    = "postgres"
  engine_version            = "16"
  instance_class            = var.db_instance_class
  allocated_storage         = 20
  max_allocated_storage     = 100
  storage_type              = "gp3"
  storage_encrypted         = true
  db_name                   = var.os_db_name
  username                  = var.os_db_username
  password                  = var.os_db_password
  port                      = 5432
  db_subnet_group_name      = aws_db_subnet_group.postgres.name
  vpc_security_group_ids    = [aws_security_group.databases.id]
  publicly_accessible       = false
  multi_az                  = var.multi_az
  backup_retention_period   = var.backup_retention_period
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.name}-os-final"
  copy_tags_to_snapshot     = true
  apply_immediately         = false
  tags                      = merge(local.common_tags, { Service = "os-service" })
}

resource "aws_db_instance" "billing" {
  identifier                = "${local.name}-billing"
  engine                    = "postgres"
  engine_version            = "16"
  instance_class            = var.db_instance_class
  allocated_storage         = 20
  max_allocated_storage     = 100
  storage_type              = "gp3"
  storage_encrypted         = true
  db_name                   = var.billing_db_name
  username                  = var.billing_db_username
  password                  = var.billing_db_password
  port                      = 5432
  db_subnet_group_name      = aws_db_subnet_group.postgres.name
  vpc_security_group_ids    = [aws_security_group.databases.id]
  publicly_accessible       = false
  multi_az                  = var.multi_az
  backup_retention_period   = var.backup_retention_period
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.name}-billing-final"
  copy_tags_to_snapshot     = true
  apply_immediately         = false
  tags                      = merge(local.common_tags, { Service = "billing-service" })
}

resource "aws_ssm_parameter" "os_connection_string" {
  name  = "/${var.project_name}/${var.environment}/database/os-connection-string"
  type  = "SecureString"
  value = "Host=${aws_db_instance.os.address};Port=5432;Database=${aws_db_instance.os.db_name};Username=${var.os_db_username};Password=${var.os_db_password}"
  tags  = local.common_tags
}

resource "aws_ssm_parameter" "billing_connection_string" {
  name  = "/${var.project_name}/${var.environment}/database/billing-connection-string"
  type  = "SecureString"
  value = "Host=${aws_db_instance.billing.address};Port=5432;Database=${aws_db_instance.billing.db_name};Username=${var.billing_db_username};Password=${var.billing_db_password}"
  tags  = local.common_tags
}

resource "aws_ssm_parameter" "execution_connection_string" {
  name  = "/${var.project_name}/${var.environment}/database/execution-connection-string"
  type  = "SecureString"
  value = var.execution_mongodb_connection_string
  tags  = local.common_tags
}
