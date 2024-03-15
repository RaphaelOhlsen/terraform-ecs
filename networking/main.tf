# Setup VPC
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "cidr_ecs_private_subnet" {}
variable "availability_zone" {}

output "lab_vpc_id" {
  value = aws_vpc.lab.id
}
  
output "lab_public_subnets" {
  value = aws_subnet.lab_public_subnets[*].id
}

output "lab_private_subnets" {
  value = aws_subnet.lab_private_subnets[*].id
}

output "lab_ecs_private_subnets" {
  value = aws_subnet.lab_ecs_private_subnets[*].id
}


output "public_subnet_cidr_block" {
  value = aws_subnet.lab_public_subnets[*].cidr_block
}

# Setup VPC
resource "aws_vpc" "lab" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Setup public subnet
resource "aws_subnet" "lab_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.lab.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "lab-public-subnet-${count.index + 1}"
  }
}

# Setup private subnet
resource "aws_subnet" "lab_private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.lab.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = "lab-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "lab_ecs_private_subnets" {
  count             = length(var.cidr_ecs_private_subnet)
  vpc_id            = aws_vpc.lab.id
  cidr_block        = element(var.cidr_ecs_private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = "lab-ecs-private-subnet-${count.index + 1}"
  }
}


/* Setup Internet Gateway for egress/ingress connections to resourses in the    ** public subnets
*/
resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab.id
  tags = {
    Name = "lab-igw"
  }
}

/* Setup NAT Gateway for egress connections to resources 
** in the private ecs subnets, it's associated with 
** the public subnet
*/
# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = element(aws_subnet.lab_public_subnets[*].id, 0)
# }

/* Setup Elastic IP for the NAT Gateway */
# resource "aws_eip" "nat" {
#   depends_on = [ aws_internet_gateway.lab_igw ]
# }

# Public Route Table with egress route to the internet
resource "aws_route_table" "lab_public_route_table" {
  vpc_id = aws_vpc.lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }
  tags = {
    Name = "lab-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "lab_public_rt_subnet_association" {
  count          = length(aws_subnet.lab_public_subnets)
  subnet_id      = aws_subnet.lab_public_subnets[count.index].id
  route_table_id = aws_route_table.lab_public_route_table.id
}

# Private Route Table
resource "aws_route_table" "lab_private_route_table" {
  vpc_id = aws_vpc.lab.id
  tags = {
    Name = "lab-private-rt"
  }
}

# Private Route Table and Private Subnet Association
resource "aws_route_table_association" "lab_private_rt_subnet_association" {
  count          = length(aws_subnet.lab_private_subnets)
  subnet_id      = aws_subnet.lab_private_subnets[count.index].id
  route_table_id = aws_route_table.lab_private_route_table.id
}
  
# ECS Route Table
resource "aws_route_table" "lab_ecs_route_table" {
  vpc_id = aws_vpc.lab.id
  
  tags = {
    Name = "lab-ecs-rt"
  }
}

# ECS Route Table and ECS Subnet Association
# resource "aws_route_table_association" "lab_ecs_rt_subnet_association" {
#   count          = length(aws_subnet.lab_ecs_private_subnets)
#   subnet_id      = aws_subnet.lab_ecs_private_subnets[count.index].id
#   # route_table_id = aws_route_table.lab_ecs_route_table.id
#   route_table_id = aws_route_table.lab_ecs_route_table.id
# }

# resource "aws_route" "private-route-to-nat" {
#   route_table_id         = aws_route_table.lab_ecs_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.nat_gw.id
# }