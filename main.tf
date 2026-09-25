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

  vpc_id         = module.network.vpc_id
  sg_name        = var.sg_name
  sg_description = var.sg_description
}

module "compute" {
  source = "./modules/compute"

  subnet_id             = module.network.public_subnets[0]
  sg_lab_id             = module.security.sg_lab_id
  instance_name         = var.instance_name
  instance_type         = var.instance_type
  ami_id                = var.ami_id
  root_volume_size      = var.root_volume_size
  root_volume_type      = var.root_volume_type
  root_volume_encrypted = var.root_volume_encrypted
}
