# ============================================
# RDS Subnet Group
# ============================================

resource "aws_db_subnet_group" "main" {
  name = "student-registration-db-subnet-group"

  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}


# ============================================
# Security Group
# ============================================

resource "aws_security_group" "rds" {
  name = "${var.project_name}-rds-sg"

  description = "Security group for Student Registration RDS"

  vpc_id = aws_vpc.main.id

  ingress {
    description = "MariaDB"

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  egress {
    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}


# ============================================
# MariaDB RDS
# ============================================

resource "aws_db_instance" "main" {
  identifier = "student-registration"

  engine = "mariadb"

  engine_version = "10.11"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  max_allocated_storage = 50

  storage_type = "gp3"

  db_name = var.db_name

  username = var.db_username

  password = var.db_password

  port = 3306

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 1

  skip_final_snapshot = true

  deletion_protection = false

  apply_immediately = true

  tags = {
    Name = "${var.project_name}-rds"
  }
}