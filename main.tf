module "networking" {
  source                  = "./networking"
  vpc_cidr                = var.vpc_cidr
  vpc_name                = var.vpc_name
  cidr_public_subnet      = var.cidr_public_subnet
  cidr_private_subnet     = var.cidr_private_subnet
  cidr_ecs_private_subnet = var.cidr_ecs_private_subnet
  availability_zone       = var.availability_zone
}

module "security_groups" {
  source                   = "./security_groups"
  bastion_host_sg_name     = "Bastion Host Security Group"
  vpc_id                   = module.networking.lab_vpc_id
  public_subnet_cidr_block = tolist(module.networking.public_subnet_cidr_block)
  my_ip                    = var.my_ip
}

module "ami_machine" {
  source = "./ami_machine"
}

# module "ec2" {
#   source = "./ec2"
#   ami_id = var.ec2_ami_id
#   # ami_id = module.ami_machine.ami_id
#   instance_type = var.ec2_instance_type
#   ec2_key_name = "awsKey"
#   subnet_id = tolist(module.networking.lab_public_subnets)[0]
#   bastion_host_sg = module.security_groups.bastion_host_sg_id
#   enable_public_ip_address = true
#   # user_data_install = templatefile("./template/ec2_install.sh", {})
# }

# module "ec2-ecs" {
#   source = "./ec2-ecs"
#   ami_id = var.ec2_ami_id
#   instance_type = var.ec2_instance_type
#   ec2_key_name = "awsKey"
#   subnet_id = tolist(module.networking.lab_ecs_private_subnets)[1]
#   ecs_sg = module.security_groups.ecs_sg_id
#   enable_public_ip_address = true
#   # user_data = templatefile("./template/ec2_install.sh")
# }

module "rds_db_instance" {
  source                 = "./rds"
  db_subnet_group_name   = "lab-rds-subnet-group"
  subnet_groups          = tolist(module.networking.lab_private_subnets)
  rds_postgres_sg_id     = module.security_groups.rds_postgres_sg_id
  postgres_db_identifier = "bia"
  postgres_username      = "postgres"
  postgres_password      = "gqt123252"
  # postgres_dbname = "labdb"
}

module "ecr" {
  source = "./ecr"
  repository_name = "lab-repo"
}

module "ecs_cluster" {
  source = "./ecs_cluster"
}

module "iam_role" {
  source = "./iam_role"
}

module "ecs_lt" {
  source           = "./ecs_lt"
  ecs_node_arn     = module.iam_role.ecs_node_arn
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
  sg_id            = module.security_groups.ecs_node_sg_id
}

module "ecs_asg" {
  source     = "./ecs_asg"
  ecs_ec2_id = module.ecs_lt.ecs_ec2_id
  subnet_id  = tolist(module.networking.lab_ecs_private_subnets)
}

module "ecs_cp" {
  source = "./ecs_cp"
  ecs_arn = module.ecs_asg.ecs_arn
}
