output "efs_id" {
  description = "ID del EFS"
  value       = aws_efs_file_system.this.id
}

output "efs_dns_name" {
  description = "DNS del EFS para montarlo por NFS"
  value       = aws_efs_file_system.this.dns_name
}

output "efs_mount_target_ids" {
  description = "IDs de los mount targets del EFS"
  value       = aws_efs_mount_target.this[*].id
}
