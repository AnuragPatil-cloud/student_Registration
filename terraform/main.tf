locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# ── VPC ───────────────────────────────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  name_prefix           = local.name_prefix
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  enable_nat_gateway    = var.enable_nat_gateway
  single_nat_gateway    = var.single_nat_gateway
  cluster_name          = "${local.name_prefix}-eks"
}

# ── IAM ───────────────────────────────────────────────────────────────────────
module "iam" {
  source = "./modules/iam"

  name_prefix  = local.name_prefix
  environment  = var.environment
  project_name = var.project_name
}

# ── EKS ───────────────────────────────────────────────────────────────────────
module "eks" {
  source = "./modules/eks"

  name_prefix        = local.name_prefix
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  node_groups        = var.node_groups
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn

  depends_on = [module.vpc, module.iam]
}

# ── RDS ───────────────────────────────────────────────────────────────────────
module "rds" {
  source = "./modules/rds"

  name_prefix               = local.name_prefix
  identifier                = var.db_identifier
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  allocated_storage         = var.db_allocated_storage
  max_allocated_storage     = var.db_max_allocated_storage
  db_name                   = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  multi_az                  = var.db_multi_az
  backup_retention_period   = var.db_backup_retention_period
  vpc_id                    = module.vpc.vpc_id
  database_subnet_ids       = module.vpc.database_subnet_ids
  allowed_security_group_id = module.eks.node_security_group_id

  depends_on = [module.vpc, module.eks]
}

# ── Route53 ───────────────────────────────────────────────────────────────────
module "route53" {
  source = "./modules/route53"

  domain_name         = var.domain_name
  create_private_zone = var.create_private_zone
  vpc_id              = module.vpc.vpc_id
  environment         = var.environment
}
