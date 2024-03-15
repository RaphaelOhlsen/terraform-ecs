########################
# Cloud Watch Logs     #
########################

output "awslogs-group" {
  value = aws_cloudwatch_log_group.ecs.name
}


resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/demo"
  retention_in_days = 14
}