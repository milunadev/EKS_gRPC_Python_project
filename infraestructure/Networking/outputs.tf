output "vpc_id" {
  value = aws_vpc.main_vpc.id
  description = "The ID of the VPC"
}


output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
  description = "List of IDs of the public subnets"
}


output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
  description = "List of IDs of the private subnets"
}
