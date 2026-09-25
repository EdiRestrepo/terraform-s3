variable "subnet_id" {
  description = "ID de la subred donde se despliega la instancia"
  type        = string
}

variable "sg_lab_id" {
  description = "ID del Security Group creado en el modulo security"
  type        = string
}

variable "instance_name" {
  description = "Prefijo de nombre para la instancia EC2"
  type        = string
  default     = "EC2-Lab-ITM"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI a usar. Si queda vacia se toma la ultima Amazon Linux 2023"
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Tamano en GiB del volumen raiz"
  type        = number
  default     = 32
}

variable "root_volume_type" {
  description = "Tipo de volumen raiz"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Cifrado del volumen raiz"
  type        = bool
  default     = false
}
