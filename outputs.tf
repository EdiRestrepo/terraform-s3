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

output "sg_lab_id" {
  description = "ID del Security Group del laboratorio"
  value       = module.security.sg_lab_id
}

output "instance_id" {
  description = "ID de la instancia EC2"
  value       = module.compute.instance_id
}

output "instance_public_ip" {
  description = "IP publica de la instancia EC2"
  value       = module.compute.instance_public_ip
}

output "instance_public_dns" {
  description = "DNS publico de la instancia EC2"
  value       = module.compute.instance_public_dns
}

output "alb_dns_name" {
  description = "DNS publico del Application Load Balancer"
  value       = module.load_balancer.alb_dns_name
}
