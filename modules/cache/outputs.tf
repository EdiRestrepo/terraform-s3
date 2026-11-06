output "redis_primary_endpoint" {
  description = "Endpoint del nodo primario de Redis"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Endpoint de lectura de Redis (replicas)"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "redis_port" {
  description = "Puerto de Redis"
  value       = aws_elasticache_replication_group.this.port
}

output "redis_auth_token" {
  description = "Token de autenticacion de Redis"
  value       = random_password.auth.result
  sensitive   = true
}

output "sg_redis_id" {
  description = "ID del Security Group de Redis"
  value       = aws_security_group.redis.id
}
