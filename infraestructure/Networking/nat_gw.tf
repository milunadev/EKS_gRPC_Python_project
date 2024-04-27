resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "EIP for NAT Gateway"
  }
}

resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[element(keys(aws_subnet.public_subnets), 0)].id

  tags = {
    Name = "${var.project_name}_nat_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_igw ]
}


