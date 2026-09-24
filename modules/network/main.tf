############# VPC #############

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.vpc_name}-${terraform.workspace}" }
}

############# Subnets #############

resource "aws_subnet" "public" {
  count                   = length(var.pub_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_subnets[count.index]
  availability_zone       = var.pub_subnets_az[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "SN-Public-${terraform.workspace}-${count.index + 1}"
    Tier = "Public"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.priv_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv_subnets[count.index]
  availability_zone = var.priv_subnets_az[count.index]
  tags = {
    Name = "SN-Private-${terraform.workspace}-${count.index + 1}"
    Tier = "Private"
  }
}

############# Internet Gateway #############

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "IGW-${terraform.workspace}" }
}

############# NAT Gateway #############

resource "aws_eip" "nat" {
  domain     = "vpc"
  tags       = { Name = "EIP-NatGW-${terraform.workspace}" }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id     = aws_eip.nat.id
  subnet_id         = aws_subnet.public[0].id
  connectivity_type = "public"
  tags              = { Name = "NGW-${terraform.workspace}" }
  depends_on        = [aws_internet_gateway.igw]
}

############# Route Tables #############

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "RT-Public-${terraform.workspace}" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "RT-Private-${terraform.workspace}" }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

############# Network ACL #############

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = { Name = "NACL-Public-${terraform.workspace}" }
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = { Name = "NACL-Private-${terraform.workspace}" }
}
