data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${local.name_prefix}-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ecs_exec_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# allow reading our basic-auth secret
data "aws_iam_policy_document" "secrets_access" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.basic_auth.arn]
  }
}

resource "aws_iam_role_policy" "ecs_exec_secrets" {
  name   = "${local.name_prefix}-secrets-access"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.secrets_access.json
}

# CloudWatch log groups (keep small retention)
resource "aws_cloudwatch_log_group" "proxy" {
  name              = "/${local.name_prefix}/proxy"
  retention_in_days = 7
  tags              = local.tags
}
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/${local.name_prefix}/frontend"
  retention_in_days = 7
  tags              = local.tags
}
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/${local.name_prefix}/backend"
  retention_in_days = 7
  tags              = local.tags
}

resource "aws_secretsmanager_secret" "basic_auth" {
  name = "${local.name_prefix}-basic-auth"
  tags = local.tags
}

output "basic_auth_secret_arn" {
  value       = aws_secretsmanager_secret.basic_auth.arn
  description = "Put a bcrypt .htpasswd line here later"
}
