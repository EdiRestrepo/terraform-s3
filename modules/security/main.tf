############# Security Group #############

resource "aws_security_group" "lab" {
  name        = "${var.sg_name}-${terraform.workspace}"
  description = var.sg_description
  vpc_id      = var.vpc_id

  tags = { Name = "${var.sg_name}-${terraform.workspace}" }
}

############# Reglas de entrada #############
resource "aws_vpc_security_group_ingress_rule" "all" {
  security_group_id = aws_security_group.lab.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

############# Reglas de salida #############

# Salida de todo el tráfico
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.lab.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# HTTP saliente
resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.lab.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}
