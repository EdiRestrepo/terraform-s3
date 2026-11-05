############# Elastic File System #############

resource "aws_efs_file_system" "this" {
  creation_token   = "${var.efs_name}-${terraform.workspace}"
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = true # Llave administrada por AWS (aws/elasticfilesystem)

  # Sin lifecycle_policy

  tags = { Name = "${var.efs_name}-${terraform.workspace}" }
}

# Backups automaticos desactivados
resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "DISABLED"
  }
}

############# Mount Targets (uno por zona de disponibilidad) #############

# Un mount target por subnet privada (una por AZ) para alta disponibilidad
resource "aws_efs_mount_target" "this" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.efs_sg_id]
}
