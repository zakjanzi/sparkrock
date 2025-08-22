resource "aws_ecr_repository" "frontend" {
  name = "${local.name_prefix}-frontend"
  image_scanning_configuration { scan_on_push = true }
  tags = local.tags
}

resource "aws_ecr_repository" "backend" {
  name = "${local.name_prefix}-backend"
  image_scanning_configuration { scan_on_push = true }
  tags = local.tags
}

resource "aws_ecr_repository" "proxy" {
  name = "${local.name_prefix}-proxy"
  image_scanning_configuration { scan_on_push = true }
  tags = local.tags
}

output "ecr_repositories" {
  description = "Repository URLs for docker push"
  value = {
    frontend = aws_ecr_repository.frontend.repository_url
    backend  = aws_ecr_repository.backend.repository_url
    proxy    = aws_ecr_repository.proxy.repository_url
  }
}
