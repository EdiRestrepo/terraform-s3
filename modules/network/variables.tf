variable "vpc_cidr" {
  description = "Rango CIDR para la VPC"
  type        = string
}

variable "vpc_name" {
  description = "Prefijo de nombre para la VPC"
  type        = string
  default     = "VPC-ITMLab-VP"
}

variable "pub_subnets" {
  description = "Lista de CIDRs para subredes publicas"
  type        = list(string)
}

variable "pub_subnets_az" {
  description = "Lista de zonas de disponibilidad para subredes publicas"
  type        = list(string)
}

variable "priv_subnets" {
  description = "Lista de CIDRs para subredes privadas"
  type        = list(string)
}

variable "priv_subnets_az" {
  description = "Lista de zonas de disponibilidad para subredes privadas"
  type        = list(string)
}
