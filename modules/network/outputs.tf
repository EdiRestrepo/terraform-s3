output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR de la VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnets" {
  description = "IDs de las subredes publicas"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "IDs de las subredes privadas"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "igw_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
