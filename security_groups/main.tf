variable "bastion_host_sg_name" {}
variable "vpc_id" {}
variable "public_subnet_cidr_block" {}
variable "my_ip" {}
  
output "bastion_host_sg_id" {
  value = aws_security_group.bastion_host_sg.id
}

output "rds_postgres_sg_id" {
  value = aws_security_group.rds_postgres_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "ecs_node_sg_id" {
  value = aws_security_group.ecs_node_sg.id
}
  

resource "aws_security_group" "bastion_host_sg" {
  name = var.bastion_host_sg_name
  description = "Enable SSH por to bastion host from my IP"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow remote SSH from my IP"
    cidr_blocks = ["${var.my_ip}/32"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  
  # ingress {
  #   description = "Allow 3001 port from my IP"
  #   cidr_blocks = ["${var.my_ip}/32"]
  #   from_port = 3001
  #   to_port = 3001
  #   protocol = "tcp"
  # }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab-bastion-host-sg"
  }
}

resource "aws_security_group" "ecs_sg" {
  name = "ecs-sg"
  description = "Enable SSH por to bastion host from my IP"
  vpc_id = var.vpc_id

  ingress {
    description = ""
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  ingress {
    description = "Allow icmp from bastion host"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab-ecs-sg"
  }
}

resource "aws_security_group" "rds_postgres_sg" {
  name = "rds-sg"
  description = "Allow acess to RDS from  "
  vpc_id = var.vpc_id

  ingress {
    description = "Allow PostgreSQL from bastion host"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  tags = {
    Name = "lab-rds-sg"
  }
}


############################################################
# Security Group for ECS Node which allow outgoing traffic #
# (its required to pull image to start service later)      #
############################################################

resource "aws_security_group" "ecs_node_sg" {
  name = "ecs-node-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = ""
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "lab-ecs-node-sg"}
}