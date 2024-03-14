variable "repository_name" {}

output "repo_url" {
  value = aws_ecr_repository.lab_repo.repository_url
}

resource "aws_ecr_repository" "lab_repo" {
  name = var.repository_name
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
