###################
#   ECS Service   #
###################

variable "vpc_id" {}
variable "vpc_cidr" {}
variable "ecs_cluster_id" {}
variable "task_definition_app_arn" {}
variable "subnet_id" {}
variable "ecs_capacity_provider_name" {}
variable "lb_target_group_app" {}

output "ecs_service_id" {
  value = aws_ecs_service.app.id
}
  

resource "aws_security_group" "ecs_task" {
  name_prefix = "ecs-task-sg-"
  description = "Allow all traffic within the VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "app" {
  name            = "app"
  cluster         = var.ecs_cluster_id
  task_definition = var.task_definition_app_arn
  desired_count   = 2

  network_configuration {
    security_groups = [aws_security_group.ecs_task.id]
    subnets         = var.subnet_id
  }

  capacity_provider_strategy {
    capacity_provider = "demo-ecs-ec2"
    base              = 1
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [var.lb_target_group_app]
}

