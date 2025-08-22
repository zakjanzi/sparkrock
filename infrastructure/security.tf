# ALB allows HTTPS from the world
resource "aws_security_group" "alb_sg" {
  name        = "${local.name_prefix}-alb-sg"
  description = "ALB SG"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.tags, { Name = "${local.name_prefix}-alb-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_in" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS from internet"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "All egress"
}

# ECS tasks accept HTTP only from ALB SG
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${local.name_prefix}-ecs-sg"
  description = "ECS tasks SG"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.tags, { Name = "${local.name_prefix}-ecs-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_http_from_alb" {
  security_group_id            = aws_security_group.ecs_tasks_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "HTTP from ALB only"
}

resource "aws_vpc_security_group_egress_rule" "ecs_all_out" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "All egress"
}
