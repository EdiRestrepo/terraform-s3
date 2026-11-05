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

############# EC2 control plane (subred publica) #############

resource "aws_instance" "control_plane" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.al2023.id
  instance_type               = var.instance_type_control_plane
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.sg_control_plane_id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.root_volume_encrypted
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install -y httpd

              systemctl start httpd
              systemctl enable httpd

              echo "<h1>Servidor EC2 funcionando</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "${var.instance_name_control_plane}-${terraform.workspace}" }
}

############# EC2 worker (subred privada) #############

resource "aws_instance" "worker" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.al2023.id
  instance_type               = var.instance_type_worker
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.sg_worker_id]
  associate_public_ip_address = false # Sale a internet por el NAT Gateway

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.root_volume_encrypted
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install -y httpd

              systemctl start httpd
              systemctl enable httpd

              echo "<h1>Servidor EC2 funcionando</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "${var.instance_name_worker}-${terraform.workspace}" }
}
