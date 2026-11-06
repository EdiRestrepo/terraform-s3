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
  description = "Version de Redis"
  type        = string
  default     = "7.1"
}

variable "node_type" {
  description = "Tipo de nodo de ElastiCache"
  type        = string
  default     = "cache.t4g.micro"
}

variable "port" {
  description = "Puerto de Redis"
  type        = number
  default     = 6379
}

variable "num_cache_clusters" {
  description = "Numero de nodos (1 = solo primario, 2+ = replicas con failover)"
  type        = number
  default     = 1
}

variable "maxmemory_policy" {
  description = "Politica de expulsion de llaves (maxmemory-policy)"
  type        = string
  default     = "allkeys-lru"
}

variable "snapshot_retention_limit" {
  description = "Dias de retencion de snapshots (0 = desactivado)"
  type        = number
  default     = 0
}

variable "snapshot_window" {
  description = "Ventana diaria de snapshots (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Ventana semanal de mantenimiento (UTC)"
  type        = string
  default     = "sun:05:00-sun:06:00"
}
