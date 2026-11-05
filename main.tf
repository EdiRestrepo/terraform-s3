module "network" {
  source = "./modules/network"

  vpc_cidr        = var.vpc_cidr
  vpc_name        = var.vpc_name
  pub_subnets     = var.pub_subnets
  pub_subnets_az  = var.pub_subnets_az
  priv_subnets    = var.priv_subnets
  priv_subnets_az = var.priv_subnets_az
}

module "security" {
  source = "./modules/security"

  vpc_id     = module.network.vpc_id
  admin_cidr = var.admin_cidr
}

module "compute" {
  source = "./modules/compute"

  public_subnet_id            = module.network.public_subnets[0]
  private_subnet_id           = module.network.private_subnets[0]
  sg_control_plane_id         = module.security.sg_control_plane_id
  sg_worker_id                = module.security.sg_worker_id
  instance_name_control_plane = var.instance_name_control_plane
  instance_name_worker        = var.instance_name_worker
  instance_type_control_plane = var.instance_type_control_plane
  instance_type_worker        = var.instance_type_worker
  ami_id                      = var.ami_id
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  root_volume_encrypted       = var.root_volume_encrypted
}

module "load_balancer" {
  source = "./modules/load_balancer"

  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
  alb_sg_id      = module.security.sg_alb_id
  instance_id    = module.compute.control_plane_id
}

module "storage" {
  source = "./modules/storage"

  efs_name   = var.efs_name
  subnet_ids = module.network.private_subnets
  efs_sg_id  = module.security.sg_efs_id
}
