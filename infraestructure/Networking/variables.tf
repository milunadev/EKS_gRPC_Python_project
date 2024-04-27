variable "availability_zones" {
  description = "List of availability zones to create subnets"  
  type = list(string)
  default = [ "sa-east-1a", "sa-east-1b", "sa-east-1c" ]
}

variable "project_name" {
  description = "Name of the project to allocate AWS resources"
  type = string
}

variable "public_subnet_number" {
  type = number
  description = "Number of public subnets to create"
}

variable "private_subnet_number" {
  type = number
  description = "Number of private subnets to create"
}