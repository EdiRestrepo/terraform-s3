locals {
  # Familia del parameter group a partir de la version mayor (7.1 -> redis7)
  engine_major = split(".", var.engine_version)[0]

  # El failover automatico y Multi-AZ solo aplican cuando hay replicas
  ha_enabled = var.num_cache_clusters > 1
}

############# Security Group de ElastiCache (Redis) #############

resource "aws_security_group" "redis" {
  name        = "SG-Redis-${terraform.workspace}"
  description = "Acceso a Redis (ElastiCache) desde los nodos K3s"
  vpc_id      = var.vpc_id

  tags = { Name = "SG-Redis-${terraform.workspace}" }
}

# Redis entrante desde el control plane
resource "aws_vpc_security_group_ingress_rule" "redis_control_plane" {
  security_group_id            = aws_security_group.redis.id
  ip_protocol                  = "tcp"
  from_port                    = var.port
  to_port                      = var.port
  referenced_security_group_id = var.sg_control_plane_id
}

# Redis entrante desde el worker
resource "aws_vpc_security_group_ingress_rule" "redis_worker" {
  security_group_id            = aws_security_group.redis.id
  ip_protocol                  = "tcp"
  from_port                    = var.port
  to_port                      = var.port
  referenced_security_group_id = var.sg_worker_id
}

# Salida de todo el trafico
resource "aws_vpc_security_group_egress_rule" "redis_all" {
  security_group_id = aws_security_group.redis.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

############# Subnet group y parameter group #############

# Subredes privadas en dos zonas de disponibilidad
resource "aws_elasticache_subnet_group" "this" {
  name        = "sng-redis-${terraform.workspace}"
  description = "Subredes privadas para Redis"
  subnet_ids  = var.subnet_ids

  tags = { Name = "sng-redis-${terraform.workspace}" }
}

resource "aws_elasticache_parameter_group" "this" {
  name        = "pg-redis-${terraform.workspace}-redis${local.engine_major}"
  family      = "redis${local.engine_major}"
  description = "Parametros Redis para ${terraform.workspace}"

  # Politica de expulsion de llaves cuando se llena la memoria
  parameter {
    name  = "maxmemory-policy"
    value = var.maxmemory_policy
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = { Name = "pg-redis-${terraform.workspace}" }
}

############# Credenciales #############

# auth_token: 16-128 caracteres, solo se usan alfanumericos
resource "random_password" "auth" {
  length  = 32
  special = false
}

############# Replication group Redis #############
# Con num_cache_clusters = 1 hay un solo nodo primario.
# Con num_cache_clusters >= 2 se agregan replicas con failover automatico.

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "redis-${terraform.workspace}"
  description          = "Redis para ${terraform.workspace}"

  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  port                 = var.port
  parameter_group_name = aws_elasticache_parameter_group.this.name

  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = local.ha_enabled
  multi_az_enabled           = local.ha_enabled

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = random_password.auth.result

  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  maintenance_window       = var.maintenance_window

  auto_minor_version_upgrade = true
  apply_immediately          = true

  tags = { Name = "redis-${terraform.workspace}" }
}
