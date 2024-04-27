output "vpc_id" {
  value = module.networking_eks.vpc_id
  description = "The ID of the VPC"
}
output "public_subnet_ids" {
  value = module.networking_eks.public_subnet_ids
  description = "IDs of the public subnets"
}

output "private_subnet_ids" {
  value = module.networking_eks.private_subnet_ids
  description = "IDs of the private subnets"
}
