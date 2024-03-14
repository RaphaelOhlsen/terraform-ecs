vpc_cidr                = "10.0.0.0/16"
vpc_name                = "lab-vpc"
cidr_public_subnet      = ["10.0.1.0/24"]
cidr_private_subnet     = ["10.0.3.0/24", "10.0.4.0/24"]
cidr_ecs_private_subnet = ["10.0.5.0/24", "10.0.6.0/24"]
availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c"]

# ec2_ami_id = "ami-07d9b9ddc6cd8dd30"
ec2_ami_id        = "ami-0f403e3180720dd7e"
ec2_instance_type = "t3.micro"
ec2_key_name      = "awsKey"

my_ip = "177.133.163.214"