output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "IDs de las subredes publicas"
  value       = module.network.public_subnets
}

output "private_subnets" {
  description = "IDs de las subredes privadas"
  value       = module.network.private_subnets
}
