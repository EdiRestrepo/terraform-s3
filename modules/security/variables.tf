variable "vpc_id" {
  description = "ID de la VPC creada en el modulo network"
  type        = string
}

variable "sg_name" {
  description = "Prefijo de nombre para el Security Group"
  type        = string
  default     = "SG-Lab-ITM"
}

variable "sg_description" {
  description = "Descripcion del Security Group"
  type        = string
  default     = "Security group prueba"
}
