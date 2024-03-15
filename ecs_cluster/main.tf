output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.arn
}

resource "aws_ecs_cluster" "main" {
  name = "lab-ecs-cluster"
}
