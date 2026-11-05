############# Control plane #############

output "control_plane_id" {
  description = "ID de la instancia EC2 control plane"
  value       = aws_instance.control_plane.id
}

output "control_plane_public_ip" {
  description = "IP publica de la instancia EC2 control plane"
  value       = aws_instance.control_plane.public_ip
}

output "control_plane_public_dns" {
  description = "DNS publico de la instancia EC2 control plane"
  value       = aws_instance.control_plane.public_dns
}

output "control_plane_private_ip" {
  description = "IP privada de la instancia EC2 control plane"
  value       = aws_instance.control_plane.private_ip
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
