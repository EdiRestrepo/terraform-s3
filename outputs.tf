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

output "master_id" {
  description = "ID de la instancia EC2 master"
  value       = module.compute.master_id
}

output "master_public_ip" {
  description = "IP publica de la instancia EC2 master"
  value       = module.compute.master_public_ip
}

output "master_public_dns" {
  description = "DNS publico de la instancia EC2 master"
  value       = module.compute.master_public_dns
}

output "master_private_ip" {
  description = "IP privada de la instancia EC2 master"
  value       = module.compute.master_private_ip
}

output "key_pair_name" {
  description = "Nombre del Key Pair creado en AWS"
  value       = module.compute.key_pair_name
}

output "ssh_private_key_path" {
  description = "Ruta local del archivo .pem para conectarse por SSH al master"
  value       = module.compute.ssh_private_key_path
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

output "db_endpoint" {
  description = "Endpoint de conexion (host:puerto) de RDS"
  value       = module.db.db_endpoint
}

output "db_password" {
  description = "Clave del usuario maestro de RDS"
  value       = module.db.db_password
  sensitive   = true
}

output "redis_primary_endpoint" {
  description = "Endpoint del nodo primario de Redis"
  value       = module.cache.redis_primary_endpoint
}

output "redis_auth_token" {
  description = "Token de autenticacion de Redis"
  value       = module.cache.redis_auth_token
  sensitive   = true
}
