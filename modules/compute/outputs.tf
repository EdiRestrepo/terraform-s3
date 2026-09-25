output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.lab.id
}

output "instance_public_ip" {
  description = "IP publica de la instancia EC2"
  value       = aws_instance.lab.public_ip
}

output "instance_public_dns" {
  description = "DNS publico de la instancia EC2"
  value       = aws_instance.lab.public_dns
}

output "instance_private_ip" {
  description = "IP privada de la instancia EC2"
  value       = aws_instance.lab.private_ip
}
