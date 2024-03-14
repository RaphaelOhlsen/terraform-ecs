variable "db_subnet_group_name" {}
variable "subnet_groups" {}
variable "rds_postgres_sg_id" {}
variable "postgres_db_identifier" {}
variable "postgres_username" {}
variable "postgres_password" {}
# variable "postgres_dbname" {}

# RDS Subneet Group
resource "aws_db_subnet_group" "lab_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_groups
  tags = {
    Name = "lab-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "lab_db_instance" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  identifier = var.postgres_db_identifier
  username             = var.postgres_username
  password             = var.postgres_password
  # db_name = var.postgres_dbname
  vpc_security_group_ids = [var.rds_postgres_sg_id]
  db_subnet_group_name = aws_db_subnet_group.lab_db_subnet_group.name
  skip_final_snapshot = true
  apply_immediately = true
  backup_retention_period = 0
  deletion_protection = false

  tags = {
    Name = "lab-db-instance"
  }
}