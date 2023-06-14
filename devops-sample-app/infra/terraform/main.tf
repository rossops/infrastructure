# https://github.com/downdetective/terraform-aws-rds
module "rds" {
  source  = "app.terraform.io/downdetective-devops/rds/aws"
  version = "1.5.1"

  name_prefix                    = "devops-sample-app"
  allocated_storage              = 20
  allow_major_upgrades           = false
  apply_immediately              = true
  auto_minor_upgrades            = true
  backup_retention               = 3
  backup_window                  = "03:00-04:00"
  dbname                         = ""
  deletion_protection            = true
  enabled_cwlogs                 = []
  engine                         = "postgres"
  engine_version                 = "14.3"
  instance_class                 = var.instance_type
  iops                           = null
  maintenance_window             = "sat:04:00-sat:05:00"
  max_allocated_storage          = 21
  monitoring_interval            = 60
  multi_az                       = false
  parameter_group_family         = "postgres14"
  performance_insights_enabled   = false
  performance_insights_retention = 7
  port                           = 5432
  replica_count                  = 0
  route53_zone_name              = "downdetective.com"
  skip_final_snapshot            = true
  snapshot_identifier            = null
  storage_encrypted              = true
  storage_type                   = "gp2"
  subnet_ids                     = var.subnet_ids
  tags                           = module.tags.standard
  username                       = "devops"
  vpc_id                         = var.vpc_id
}

# https://github.com/downdetective/terraform-aws-redis-replication-group
module "redis-replication-group" {
  source  = "app.terraform.io/downdetective-devops/redis-replication-group/aws"
  version = "1.4.0"

  apply_immediately        = true
  egress_cidr_blocks       = ["0.0.0.0/0"]
  engine_version           = "7.x"
  extra_replica_count      = 0
  idle_connection_timeout  = "300"
  ingress_cidr_blocks      = ["10.0.0.0/8"]
  initial_replica_count    = 2
  maxmemory_policy         = "volatile-lru"
  name                     = "devops-sample-app"
  node_type                = "cache.t4g.micro"
  parameter_group_family   = "redis7"
  snapshot_retention_limit = 0
  snapshot_window          = "00:00-05:00"
  subnets                  = var.subnet_ids
  vpc_id                   = var.vpc_id
}

# https://github.com/downdetective/terraform-aws-tags
module "tags" {
  source  = "app.terraform.io/downdetective-devops/tags/aws"
  version = "1.0.1"

  region              = var.aws_region
  environment         = var.environment
  project_repo        = "downdetective/devops-sample-app"
  infrastructure_repo = "downdetective/devops-sample-app"
  role                = ""
  product             = "devops-sample-app"
  tenant              = ""
}
