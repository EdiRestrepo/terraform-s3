############# Master #############

output "master_id" {
  description = "ID de la instancia EC2 master"
  value       = aws_instance.master.id
}

output "master_public_ip" {
  description = "IP publica de la instancia EC2 master"
  value       = aws_instance.master.public_ip
}

output "master_public_dns" {
  description = "DNS publico de la instancia EC2 master"
  value       = aws_instance.master.public_dns
}

output "master_private_ip" {
  description = "IP privada de la instancia EC2 master"
  value       = aws_instance.master.private_ip
}

############# Worker #############

output "worker_id" {
  description = "ID de la instancia EC2 worker"
  value       = aws_instance.worker.id
}

output "worker_private_ip" {
  description = "IP privada de la instancia EC2 worker"
  value       = aws_instance.worker.private_ip
}

############# SSH #############

output "key_pair_name" {
  description = "Nombre del Key Pair creado en AWS"
  value       = aws_key_pair.this.key_name
}

output "ssh_private_key_path" {
  description = "Ruta local del archivo .pem para conectarse por SSH"
  value       = local_sensitive_file.pem.filename
}
