variable "vpc_id" {
  description = "ID de la VPC creada en el modulo network"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subredes privadas del subnet group (una por AZ)"
  type        = list(string)
}

variable "sg_control_plane_id" {
  description = "ID del Security Group del control plane (origen permitido)"
  type        = string
}

variable "sg_worker_id" {
  description = "ID del Security Group del worker (origen permitido)"
  type        = string
}

variable "engine_version" {
  description = "Version de PostgreSQL"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "Clase de instancia RDS"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Almacenamiento inicial en GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Limite de autoescalado de almacenamiento en GiB (0 = desactivado)"
  type        = number
  default     = 0
}

variable "db_name" {
  description = "Nombre de la base de datos inicial"
  type        = string
  default     = "n8n"
}

variable "db_username" {
  description = "Usuario maestro de la base de datos"
  type        = string
  default     = "n8n_admin"
}

variable "db_port" {
  description = "Puerto de PostgreSQL"
  type        = number
  default     = 5432
}

variable "multi_az" {
  description = "Habilita standby en otra AZ (Multi-AZ)"
  type        = bool
  default     = false
}

variable "force_ssl" {
  description = "Obliga conexiones SSL (rds.force_ssl)"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Dias de retencion de backups automaticos"
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "Protege la instancia contra borrado"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Omite el snapshot final al destruir la instancia"
  type        = bool
  default     = true
}
