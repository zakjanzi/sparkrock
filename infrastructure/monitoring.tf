# SNS topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${local.name_prefix}-alerts"
  tags = local.tags
}

# Email sub
resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = local.tags["OwnerEmail"]
}

# CPU > 70% alarm for the ECS service
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${local.name_prefix}-cpu-high"
  alarm_description   = "CPU > 70% for ECS service ${aws_ecs_service.app.name}"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300              # 5 minutes
  evaluation_periods  = 2
  threshold           = 70
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.app.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  tags          = local.tags
}

output "sns_topic_arn"   { value = aws_sns_topic.alerts.arn }
output "cpu_alarm_name"  { value = aws_cloudwatch_metric_alarm.ecs_cpu_high.alarm_name }
