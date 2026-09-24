module "network" {
  source = "./modules/network"

  vpc_cidr        = var.vpc_cidr
  vpc_name        = var.vpc_name
  pub_subnets     = var.pub_subnets
  pub_subnets_az  = var.pub_subnets_az
  priv_subnets    = var.priv_subnets
  priv_subnets_az = var.priv_subnets_az
}
