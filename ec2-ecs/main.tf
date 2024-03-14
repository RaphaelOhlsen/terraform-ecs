variable "ami_id" {}
variable "instance_type" {}
variable "ec2_key_name" {}
variable "subnet_id" {}
variable "ecs_sg" {}
variable "enable_public_ip_address" {}
# variable "user_data" {}

resource "aws_instance" "ec2-ecs" {  
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.ec2_key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.ecs_sg]
  # associate_public_ip_address = var.enable_public_ip_address

  # user_data = var.user_data

  tags = {
    Name = "ec2-ecs"
  }
  
}