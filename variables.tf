########## Provider ##########

variable "aws_region" {
  description = "Region de AWS donde se crean los recursos"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil de AWS CLI usado para autenticar"
  type        = string
  default     = "PSeminario"
}

########## VPC ##########

variable "vpc_cidr" {
  description = "Rango CIDR para la VPC"
  type        = string
  default     = "192.168.0.0/24"
}

variable "vpc_name" {
  description = "Prefijo de nombre para la VPC"
  type        = string
  default     = "VPC-ITMLab-VP"
}

########## Subredes publicas (Front) ##########

variable "pub_subnets" {
  description = "Lista de CIDRs para subredes publicas"
  type        = list(string)
  default     = ["192.168.0.0/27", "192.168.0.32/27"]
}

variable "pub_subnets_az" {
  description = "Lista de zonas de disponibilidad para subredes publicas"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1d"]
}

########## Subredes privadas (Back) ##########

variable "priv_subnets" {
  description = "Lista de CIDRs para subredes privadas"
  type        = list(string)
  default     = ["192.168.0.64/27", "192.168.0.96/27"]
}

variable "priv_subnets_az" {
  description = "Lista de zonas de disponibilidad para subredes privadas"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1d"]
}

########## Security Group ##########

variable "admin_cidr" {
  description = "CIDR desde el que se permite SSH y kubectl (6443) al control plane"
  type        = string
  default     = "0.0.0.0/0"
}

########## EC2 ##########

variable "instance_name_control_plane" {
  description = "Prefijo de nombre para la instancia EC2 control plane"
  type        = string
  default     = "EC2-Lab-ITM-Control-Plane"
}

variable "instance_name_worker" {
  description = "Prefijo de nombre para la instancia EC2 worker"
  type        = string
  default     = "EC2-Lab-ITM-Worker"
}

variable "instance_type_control_plane" {
  description = "Tipo de instancia EC2 del control plane"
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

########## EFS ##########

variable "efs_name" {
  description = "Prefijo de nombre para el EFS"
  type        = string
  default     = "efs-itm-lab"
}

########## RDS ##########

variable "db_engine_version" {
  description = "Version de PostgreSQL (mayor o mayor.menor)"
  type        = string
  default     = "16"
}

variable "db_instance_class" {
  description = "Clase de instancia RDS"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Almacenamiento inicial de RDS en GiB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Limite de autoescalado de almacenamiento de RDS en GiB (0 = desactivado)"
  type        = number
  default     = 50
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

variable "db_multi_az" {
  description = "Habilita standby de RDS en otra AZ"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Dias de retencion de backups automaticos de RDS"
  type        = number
  default     = 7
}

variable "db_deletion_protection" {
  description = "Protege la instancia RDS contra borrado"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Omite el snapshot final al destruir RDS"
  type        = bool
  default     = true
}

########## ElastiCache ##########

variable "redis_engine_version" {
  description = "Version de Redis"
  type        = string
  default     = "7.1"
}

variable "redis_node_type" {
  description = "Tipo de nodo de ElastiCache"
  type        = string
  default     = "cache.t4g.micro"
}

variable "redis_num_cache_clusters" {
  description = "Numero de nodos Redis (1 = solo primario, 2+ = replicas con failover)"
  type        = number
  default     = 1
}

variable "redis_snapshot_retention_limit" {
  description = "Dias de retencion de snapshots de Redis (0 = desactivado)"
  type        = number
  default     = 7
}
