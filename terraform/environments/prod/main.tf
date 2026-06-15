module "infrastructure" {
  source = "../../"

  # General
  environment  = "prod"
  project_name = var.project_name
  aws_region   = var.aws_region
  aws_profile  = var.aws_profile

  # VPC
  vpc_cidr              = "10.0.0.0/16"
  availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnet_cidrs = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
  enable_nat_gateway    = true
  single_nat_gateway    = false # HA: one NAT per AZ in prod

  # EKS
  cluster_version = "1.29"
  node_groups = {
    general = {
      instance_types = ["t3.large"]
      desired_size   = 3
      min_size       = 2
      max_size       = 10
      disk_size      = 100
      labels         = { role = "general", env = "prod" }
      taints         = []
    }
    compute = {
      instance_types = ["c5.xlarge"]
      desired_size   = 2
      min_size       = 1
      max_size       = 20
      disk_size      = 100
      labels         = { role = "compute", env = "prod" }
      taints = [{
        key    = "dedicated"
        value  = "compute"
        effect = "NO_SCHEDULE"
      }]
    }
  }

  # RDS
  db_identifier             = "${var.project_name}-prod-db"
  db_engine                 = "postgres"
  db_engine_version         = "15.4"
  db_instance_class         = "db.r6g.large"
  db_allocated_storage      = 100
  db_max_allocated_storage  = 500
  db_name                   = var.db_name
  db_username               = var.db_username
  db_password               = var.db_password
  db_multi_az               = true
  db_backup_retention_period = 14

  # Route53
  domain_name         = var.domain_name
  create_private_zone = true
}
