variable "vpc_id" {
  description = "ID de la VPC creada en el modulo network"
  type        = string
}

variable "public_subnets" {
  description = "IDs de las subredes publicas para el ALB (minimo 2 en AZs distintas)"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ID del Security Group del ALB creado en el modulo security"
  type        = string
}

variable "instance_id" {
  description = "ID de la instancia EC2 que se registra en el Target Group"
  type        = string
}
