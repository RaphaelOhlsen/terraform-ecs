output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

resource "aws_ecs_cluster" "main" {
  name = "lab-ecs-cluster"
}



