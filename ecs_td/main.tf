###########################
#   ECS Task Definition   #
###########################

variable "ecs_task_role_arn" {}
variable "ecs_exec_role_arn" {}
variable "demo_app_repo_url" {}
variable "awslogs-group" {}

output "task_definition_app_arn" {
  value = aws_ecs_task_definition.app.arn
}

resource "aws_ecs_task_definition" "app" {
  family             = "demo-app"
  task_role_arn      = var.ecs_task_role_arn
  execution_role_arn = var.ecs_exec_role_arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 256

  container_definitions = jsonencode([{
    name         = "app",
    image        = "${var.demo_app_repo_url}:latest",
    essential    = true,
    portMappings = [{ containerPort = 80, hostPort = 80 }],

    environment = [
      { name = "EXAMPLE", value = "example" }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "us-east-1",
        "awslogs-group"         = var.awslogs-group,
        "awslogs-stream-prefix" = "app"
      }
    },
  }])
}