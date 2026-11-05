variable "vpc_id" {
  description = "ID de la VPC creada en el modulo network"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR desde el que se permite SSH y kubectl (6443) al control plane"
  type        = string
  default     = "0.0.0.0/0"
}
