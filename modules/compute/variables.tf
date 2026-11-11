variable "public_subnet_id" {
  description = "ID de la subred publica donde se despliega el master"
  type        = string
}

variable "private_subnet_id" {
  description = "ID de la subred privada donde se despliega el worker"
  type        = string
}

variable "sg_master_id" {
  description = "ID del Security Group del master creado en el modulo security"
  type        = string
}

variable "sg_worker_id" {
  description = "ID del Security Group del worker creado en el modulo security"
  type        = string
}

variable "instance_name_master" {
  description = "Prefijo de nombre para la instancia EC2 master"
  type        = string
  default     = "EC2-Lab-ITM-Master"
}

variable "instance_name_worker" {
  description = "Prefijo de nombre para la instancia EC2 worker"
  type        = string
  default     = "EC2-Lab-ITM-Worker"
}

variable "instance_type_master" {
  description = "Tipo de instancia EC2 del master"
  type        = string
  default     = "t3.medium"
}

variable "instance_type_worker" {
  description = "Tipo de instancia EC2 del worker"
  type        = string
  default     = "t3.large"
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

variable "key_pair_name" {
  description = "Prefijo del Key Pair que Terraform crea para SSH a las instancias"
  type        = string
  default     = "KP-ITMLab"
}
