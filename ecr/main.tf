variable "repository_name" {}

output "demo_app_repo_url" {
  value = aws_ecr_repository.app.repository_url
}

resource "aws_ecr_repository" "app" {
  name = var.repository_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "lab-repo"
  }
}
