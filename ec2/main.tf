variable "ami_id" {}
variable "instance_type" {}
variable "ec2_key_name" {}
variable "subnet_id" {}
variable "bastion_host_sg" {}
variable "enable_public_ip_address" {}
# variable "user_data_install" {}

resource "aws_instance" "bastion_host" {  
  ami = var.ami_id
  # ami = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name = var.ec2_key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.bastion_host_sg]
  # associate_public_ip_address = var.enable_public_ip_address

  user_data = <<-EOF
              echo "Creating a file named teste.txt"
              echo "Hello, this is a test file!" > ./teste.txt
              EOF

  tags = {
    Name = "bastion-host"
  }
  
}