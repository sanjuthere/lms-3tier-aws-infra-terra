# VPC
output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

# Subnets
output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  description = "The IDs of the private subnets"
}

# NAT Gateways
output "nat_gateway_ids" {
  value = [aws_nat_gateway.nat_a.id, aws_nat_gateway.nat_b.id]
  description = "The IDs of the NAT gateways"
}

# EC2 Instances
output "public_instance_public_ip" {
  value = aws_instance.public_instance.public_ip
  description = "The public IP of the public EC2 instance"
}

output "private_instance_private_ip" {
  value = aws_instance.private_instance.private_ip
  description = "The private IP of the private EC2 instance"
}

# Application Load Balancers
output "external_alb_dns" {
  value = aws_lb.external.dns_name
  description = "The DNS name of the external Application Load Balancer"
}

output "internal_alb_dns" {
  value = aws_lb.internal.dns_name
  description = "The DNS name of the internal Application Load Balancer"
}
