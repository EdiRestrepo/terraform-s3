variable "efs_name" {
  description = "Prefijo de nombre para el EFS"
  type        = string
  default     = "efs-itm-lab"
}

variable "subnet_ids" {
  description = "IDs de las subredes donde se crean los mount targets (una por AZ)"
  type        = list(string)
}

variable "efs_sg_id" {
  description = "ID del Security Group del EFS creado en el modulo security"
  type        = string
}

variable "performance_mode" {
  description = "Modo de rendimiento del EFS (generalPurpose o maxIO)"
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  description = "Modo de throughput del EFS (bursting, provisioned o elastic)"
  type        = string
  default     = "bursting"
}
