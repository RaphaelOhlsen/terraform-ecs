variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR value"
}

variable "vpc_name" {
  type        = string
  description = "Lab VPC"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "cidr_ecs_private_subnet" {
  type        = list(string)
  description = "ECS Private Subnet CIDR values"
}

variable "availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "ec2_ami_id" {
  type        = string
  description = "Lab AMI Id for EC2 instance"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ec2_key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "my_ip" {
  type        = string
  sensitive   = true
  description = "My IP address"
}