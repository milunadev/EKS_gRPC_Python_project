## Utilizamos un bloque locals para predefinir un mapa que representa nuestras subredes. Las claves de este mapa no dependen de ningún recurso de AWS y por tanto están disponibles en tiempo de planificación.

locals {
  public_subnets = { for idx in range(var.public_subnet_number) : "${element(var.availability_zones, idx % length(var.availability_zones))}-public-${idx}" => {
    az = element(var.availability_zones, idx % length(var.availability_zones))
    cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, idx)
  }}

  private_subnets = { for idx in range(var.private_subnet_number) : "${element(var.availability_zones, idx % length(var.availability_zones))}-private-${idx}" => {
    az = element(var.availability_zones, idx % length(var.availability_zones))
    cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, idx + var.public_subnet_number)
  }}
}

##################################################
# PUBLIC SUBNETS
##################################################  

resource "aws_subnet" "public_subnets" {
  for_each                 = local.public_subnets
  vpc_id                   = aws_vpc.main_vpc.id
  cidr_block               = each.value.cidr_block
  map_public_ip_on_launch  = true
  availability_zone        = each.value.az

  tags = {
    "Name" = "${var.project_name}_${each.key}"
    "kubernetes.io/role/elb"            = "1"
  }
}


##################################################
# PRIVATE SUBNETS
##################################################  


resource "aws_subnet" "private_subnets" {
  for_each                 = local.private_subnets
  vpc_id                   = aws_vpc.main_vpc.id
  cidr_block               = each.value.cidr_block
  availability_zone        = each.value.az
  map_public_ip_on_launch  = false

  tags = {
    Name = "${var.project_name}_${each.key}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
