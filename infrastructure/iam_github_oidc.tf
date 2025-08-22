# OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # GitHub OIDC root CA thumbprint (DigiCert Global Root G2)
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Trust policy so ONLY my repo on the main branch can assume the role
data "aws_iam_policy_document" "gha_oidc_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:zakjanzi/sparkrock:ref:refs/heads/main"]
    }
  }
}

# Role assumed by GitHub Actions for deploys
resource "aws_iam_role" "gha_deploy" {
  name               = "${local.name_prefix}-gha-deploy"
  assume_role_policy = data.aws_iam_policy_document.gha_oidc_trust.json
  tags               = local.tags
}

# needed to build ARNs
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Compute ECS ARNs explicitly
locals {
  ecs_cluster_arn = aws_ecs_cluster.main.arn
  ecs_service_arn = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${aws_ecs_cluster.main.name}/${aws_ecs_service.app.name}"
}

# Least-privilege policy for GitHub Actions
data "aws_iam_policy_document" "gha_permissions" {
  # Get ECR auth token
  statement {
    sid     = "ECRGetToken"
    actions = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # Push/pull only our three repos
  statement {
    sid = "ECRPushPull"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = [
      aws_ecr_repository.frontend.arn,
      aws_ecr_repository.backend.arn,
      aws_ecr_repository.proxy.arn
    ]
  }

  # Update the specific ECS service
  statement {
    sid       = "ECSUpdateService"
    actions   = ["ecs:UpdateService"]
    resources = [local.ecs_service_arn]
  }

  # Read-only ECS describes/lists (these are effectively "*" in AWS IAM)
  statement {
    sid = "ECSRead"
    actions = [
      "ecs:DescribeServices",
      "ecs:ListTasks",
      "ecs:DescribeTasks"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "gha_inline" {
  role   = aws_iam_role.gha_deploy.id
  policy = data.aws_iam_policy_document.gha_permissions.json
}


output "gha_role_arn" {
  value = aws_iam_role.gha_deploy.arn
}
