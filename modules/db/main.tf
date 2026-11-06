locals {
  # Familia del parameter group a partir de la version mayor (16 -> postgres16)
  engine_major = split(".", var.engine_version)[0]
}

############# Security Group de RDS #############

resource "aws_security_group" "db" {
  name        = "SG-RDS-${terraform.workspace}"
  description = "Security group de la base de datos RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = { Name = "SG-RDS-${terraform.workspace}" }
}

# PostgreSQL entrante desde el control plane
resource "aws_vpc_security_group_ingress_rule" "db_pg_control_plane" {
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
  referenced_security_group_id = var.sg_control_plane_id
}

# PostgreSQL entrante desde el worker
resource "aws_vpc_security_group_ingress_rule" "db_pg_worker" {
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
  referenced_security_group_id = var.sg_worker_id
}

# Salida de todo el trafico
resource "aws_vpc_security_group_egress_rule" "db_all" {
  security_group_id = aws_security_group.db.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

############# Subnet group y parameter group #############

# Subredes privadas en dos zonas de disponibilidad
resource "aws_db_subnet_group" "this" {
  name       = "sng-db-${terraform.workspace}"
  subnet_ids = var.subnet_ids

  tags = { Name = "sng-db-${terraform.workspace}" }
}

resource "aws_db_parameter_group" "this" {
  name_prefix = "pg-db-${terraform.workspace}-postgres${local.engine_major}-"
  family      = "postgres${local.engine_major}"
  description = "Parametros PostgreSQL para ${terraform.workspace}"

  parameter {
    name  = "rds.force_ssl"
    value = var.force_ssl ? "1" : "0"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = { Name = "pg-db-${terraform.workspace}" }
}

############# Credenciales #############

# RDS no admite / @ " ' ni espacios en la clave maestra
resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

############# Instancia RDS PostgreSQL (privada) #############

resource "aws_db_instance" "this" {
  identifier = "db-${terraform.workspace}"

  engine                     = "postgres"
  engine_version             = var.engine_version
  auto_minor_version_upgrade = true
  instance_class             = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.master.result
  port     = var.db_port

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  parameter_group_name   = aws_db_parameter_group.this.name

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:30-sun:05:30"
  copy_tags_to_snapshot   = true

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "db-${terraform.workspace}-final"
  apply_immediately         = true

  tags = { Name = "db-${terraform.workspace}" }
}
