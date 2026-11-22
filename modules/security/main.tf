############# Security Group del ALB #############

resource "aws_security_group" "alb" {
  name        = "SG-ALB-${terraform.workspace}"
  description = "Security group del Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = { Name = "SG-ALB-${terraform.workspace}" }
}

# HTTP entrante desde internet
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

# Salida de todo el tráfico (hacia los targets y health checks)
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

############# Security Group del EFS #############

resource "aws_security_group" "efs" {
  name        = "SG-EFS-${terraform.workspace}"
  description = "Security group del Elastic File System"
  vpc_id      = var.vpc_id

  tags = { Name = "SG-EFS-${terraform.workspace}" }
}

# NFS entrante desde el master
resource "aws_vpc_security_group_ingress_rule" "efs_nfs_master" {
  security_group_id            = aws_security_group.efs.id
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
  referenced_security_group_id = aws_security_group.master.id
}

# NFS entrante desde el worker
resource "aws_vpc_security_group_ingress_rule" "efs_nfs_worker" {
  security_group_id            = aws_security_group.efs.id
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
  referenced_security_group_id = aws_security_group.worker.id
}

# Salida de todo el tráfico
resource "aws_vpc_security_group_egress_rule" "efs_all" {
  security_group_id = aws_security_group.efs.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

############# Security Group del master (subred publica) #############

resource "aws_security_group" "master" {
  name        = "SG-Master-${terraform.workspace}"
  description = "Security group de la instancia master"
  vpc_id      = var.vpc_id

  tags = { Name = "SG-Master-${terraform.workspace}" }
}

# SSH entrante para administracion (tambien sirve de bastion hacia el worker)
resource "aws_vpc_security_group_ingress_rule" "master_ssh" {
  security_group_id = aws_security_group.master.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.admin_cidr
}

# API de Kubernetes (kubectl) desde el administrador
resource "aws_vpc_security_group_ingress_rule" "master_api_admin" {
  security_group_id = aws_security_group.master.id
  ip_protocol       = "tcp"
  from_port         = 6443
  to_port           = 6443
  cidr_ipv4         = var.admin_cidr
}

# API de Kubernetes desde el worker (registro del nodo)
resource "aws_vpc_security_group_ingress_rule" "master_api_worker" {
  security_group_id            = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 6443
  to_port                      = 6443
  referenced_security_group_id = aws_security_group.worker.id
}

# Kubelet desde el worker
resource "aws_vpc_security_group_ingress_rule" "master_kubelet_worker" {
  security_group_id            = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10250
  referenced_security_group_id = aws_security_group.worker.id
}

# Flannel VXLAN (red de los pods) desde el worker
resource "aws_vpc_security_group_ingress_rule" "master_flannel_worker" {
  security_group_id            = aws_security_group.master.id
  ip_protocol                  = "udp"
  from_port                    = 8472
  to_port                      = 8472
  referenced_security_group_id = aws_security_group.worker.id
}

# HTTP desde el ALB
resource "aws_vpc_security_group_ingress_rule" "master_http_alb" {
  security_group_id            = aws_security_group.master.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.alb.id
}

# Rango NodePort de Kubernetes desde el administrador (n8n se expone en 30678)
resource "aws_vpc_security_group_ingress_rule" "master_nodeport_admin" {
  security_group_id = aws_security_group.master.id
  ip_protocol       = "tcp"
  from_port         = 30000
  to_port           = 32767
  cidr_ipv4         = var.admin_cidr
}

# Salida de todo el tráfico
resource "aws_vpc_security_group_egress_rule" "master_all" {
  security_group_id = aws_security_group.master.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

############# Security Group del worker (subred privada) #############

resource "aws_security_group" "worker" {
  name        = "SG-Worker-${terraform.workspace}"
  description = "Security group de la instancia worker"
  vpc_id      = var.vpc_id

  tags = { Name = "SG-Worker-${terraform.workspace}" }
}

# SSH solo desde el master (bastion)
resource "aws_vpc_security_group_ingress_rule" "worker_ssh_master" {
  security_group_id            = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = aws_security_group.master.id
}

# Kubelet desde el master (logs, exec, metrics)
resource "aws_vpc_security_group_ingress_rule" "worker_kubelet_master" {
  security_group_id            = aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10250
  referenced_security_group_id = aws_security_group.master.id
}

# Flannel VXLAN desde el master
resource "aws_vpc_security_group_ingress_rule" "worker_flannel_master" {
  security_group_id            = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 8472
  to_port                      = 8472
  referenced_security_group_id = aws_security_group.master.id
}

# Flannel VXLAN entre workers (si se agregan mas)
resource "aws_vpc_security_group_ingress_rule" "worker_flannel_self" {
  security_group_id            = aws_security_group.worker.id
  ip_protocol                  = "udp"
  from_port                    = 8472
  to_port                      = 8472
  referenced_security_group_id = aws_security_group.worker.id
}

# Salida de todo el tráfico (por el NAT Gateway)
resource "aws_vpc_security_group_egress_rule" "worker_all" {
  security_group_id = aws_security_group.worker.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
