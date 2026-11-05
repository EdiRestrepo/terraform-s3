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

output "control_plane_id" {
  description = "ID de la instancia EC2 control plane"
  value       = module.compute.control_plane_id
}

output "control_plane_public_ip" {
  description = "IP publica de la instancia EC2 control plane"
  value       = module.compute.control_plane_public_ip
}

output "control_plane_public_dns" {
  description = "DNS publico de la instancia EC2 control plane"
  value       = module.compute.control_plane_public_dns
}

output "control_plane_private_ip" {
  description = "IP privada de la instancia EC2 control plane"
  value       = module.compute.control_plane_private_ip
}

output "worker_id" {
  description = "ID de la instancia EC2 worker"
  value       = module.compute.worker_id
}

output "worker_private_ip" {
  description = "IP privada de la instancia EC2 worker"
  value       = module.compute.worker_private_ip
}

output "alb_dns_name" {
  description = "DNS publico del Application Load Balancer"
  value       = module.load_balancer.alb_dns_name
}

output "efs_id" {
  description = "ID del EFS"
  value       = module.storage.efs_id
}

output "efs_dns_name" {
  description = "DNS del EFS para montarlo por NFS"
  value       = module.storage.efs_dns_name
}
