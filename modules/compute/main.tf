############# AMI #############

# Ultima Amazon Linux 2023 x86_64. Se usa solo si no se fija var.ami_id.
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

############# Key pair para SSH #############

# Terraform genera la llave, registra la publica en AWS y guarda la privada
# en keys/<nombre>.pem en la raiz del proyecto (*.pem esta en .gitignore).
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.key_pair_name}-${terraform.workspace}"
  public_key = tls_private_key.ssh.public_key_openssh

  tags = { Name = "${var.key_pair_name}-${terraform.workspace}" }
}

resource "local_sensitive_file" "pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.root}/keys/${aws_key_pair.this.key_name}.pem"
  file_permission = "0400"
}

############# Token del cluster K3s #############

# Token compartido entre master y worker para unir el nodo al cluster
resource "random_password" "k3s_token" {
  length  = 48
  special = false
}

############# EC2 master K3s (subred publica) #############

resource "aws_instance" "master" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.al2023.id
  instance_type               = var.instance_type_master
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.sg_master_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.root_volume_encrypted
    delete_on_termination = true
  }

  # El user_data solo corre en el primer arranque: si cambia, se recrea la instancia
  user_data_replace_on_change = true

  # AL2023 exige IMDSv2: primero se pide un token para leer la metadata.
  # --tls-san agrega la IP publica al certificado del API para conectarse desde OpenLens.
  user_data = <<-EOF
              #!/bin/bash
              IMDS_TOKEN=$(curl -s -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
              PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
              curl -sfL https://get.k3s.io | K3S_TOKEN=${random_password.k3s_token.result} sh -s server \
              --tls-san=$PUBLIC_IP --write-kubeconfig-mode 644
              EOF

  tags = {
    Name = "${var.instance_name_master}-${terraform.workspace}"
    Role = "k3s-master"
  }
}

############# EC2 worker K3s (subred privada) #############

resource "aws_instance" "worker" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.al2023.id
  instance_type               = var.instance_type_worker
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.sg_worker_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = false # Sale a internet por el NAT Gateway

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.root_volume_encrypted
    delete_on_termination = true
  }

  user_data_replace_on_change = true

  # Espera a que el master levante el API (6443) y se une al cluster como agente
  user_data = <<-EOF
              #!/bin/bash
              sleep 60
              curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.master.private_ip}:6443 \
              K3S_TOKEN=${random_password.k3s_token.result} sh -
              EOF

  tags = {
    Name = "${var.instance_name_worker}-${terraform.workspace}"
    Role = "k3s-worker"
  }
}
