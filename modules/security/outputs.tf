output "sg_alb_id" {
  description = "ID del Security Group del ALB"
  value       = aws_security_group.alb.id
}

output "sg_efs_id" {
  description = "ID del Security Group del EFS"
  value       = aws_security_group.efs.id
}

output "sg_master_id" {
  description = "ID del Security Group del master"
  value       = aws_security_group.master.id
}

output "sg_worker_id" {
  description = "ID del Security Group del worker"
  value       = aws_security_group.worker.id
}
