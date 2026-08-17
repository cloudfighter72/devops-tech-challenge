# Backend ECR Repo
resource "aws_ecr_repository" "backend" {
  name                 = "node-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "node-backend-repo"
  }
}

# Frontend ECR Repo
resource "aws_ecr_repository" "frontend" {
  name                 = "node-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "node-frontend-repo"
  }
}