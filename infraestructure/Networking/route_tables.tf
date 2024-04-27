##################################################
# PUBLIC ROUTE TABLES AND ASSOCIATIONS
##################################################  

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.project_name}_public_route_table"
  }

  
}


resource "aws_route_table_association" "public_associations" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}


##################################################
# PRIVATE ROUTE TABLES AND ASSOCIATIONS
##################################################  

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gw.id
  }
  tags = {
    Name = "${var.project_name}_private_route_table"
  }
}


resource "aws_route_table_association" "private_associations" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}