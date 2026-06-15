# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow access from EKS nodes"
    from_port       = local.db_port
    to_port         = local.db_port
    protocol        = "tcp"
    security_groups = [var.allowed_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}

locals {
  db_port = var.engine == "postgres" ? 5432 : 3306
}

# ── DB Parameter Group ────────────────────────────────────────────────────────
resource "aws_db_parameter_group" "this" {
  name   = "${var.name_prefix}-${var.engine}-params"
  family = "${var.engine}${split(".", var.engine_version)[0]}"

  dynamic "parameter" {
    for_each = var.engine == "postgres" ? [
      { name = "log_connections", value = "1" },
      { name = "log_disconnections", value = "1" },
      { name = "log_duration", value = "1" },
      { name = "log_statement", value = "ddl" },
    ] : []
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = {
    Name = "${var.name_prefix}-${var.engine}-params"
  }
}

# ── DB Subnet Group ───────────────────────────────────────────────────────────
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

# ── RDS Instance ──────────────────────────────────────────────────────────────
resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = local.db_port

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.this.name

  backup_retention_period   = var.backup_retention_period
  backup_window             = "03:00-04:00"
  maintenance_window        = "Mon:04:00-Mon:05:00"
  auto_minor_version_upgrade = true

  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.identifier}-final-snapshot"
  copy_tags_to_snapshot     = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  enabled_cloudwatch_logs_exports = var.engine == "postgres" ? [
    "postgresql", "upgrade"
  ] : ["general", "error", "slowquery"]

  tags = {
    Name = var.identifier
  }

  lifecycle {
    ignore_changes = [password]
  }
}
