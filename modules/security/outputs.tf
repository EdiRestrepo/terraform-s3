output "sg_lab_id" {
  description = "ID del Security Group del laboratorio"
  value       = aws_security_group.lab.id
}

output "sg_lab_name" {
  description = "Nombre del Security Group del laboratorio"
  value       = aws_security_group.lab.name
}
