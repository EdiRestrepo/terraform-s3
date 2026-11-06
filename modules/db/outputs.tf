output "db_endpoint" {
  description = "Endpoint de conexion (host:puerto) de RDS"
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Hostname de RDS"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Puerto de RDS"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Nombre de la base de datos"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "Usuario maestro de la base de datos"
  value       = aws_db_instance.this.username
}

output "db_password" {
  description = "Clave del usuario maestro"
  value       = random_password.master.result
  sensitive   = true
}

output "sg_db_id" {
  description = "ID del Security Group de RDS"
  value       = aws_security_group.db.id
}
