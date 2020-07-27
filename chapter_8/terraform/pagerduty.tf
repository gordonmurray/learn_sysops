locals {
  integration_key = ""
}

# Pagerduty user
resource "pagerduty_user" "example" {
  name  = "example"
  email = "example@domain.com"
}

# Pagerduty Team
resource "pagerduty_team" "example" {
  name        = "example team"
  description = "An example Pagerduty team"
}

# Assign user to team
resource "pagerduty_team_membership" "example" {
  user_id = pagerduty_user.example.id
  team_id = pagerduty_team.example.id
  role    = "manager"
}

# AWS SNS topic 
resource "aws_sns_topic" "pagerduty_noticiation" {
  name = "user-updates-topic"
}

# AWS SNS topic subscription 
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.pagerduty_noticiation.arn
  protocol  = "HTTPS"
  endpoint  = "https://events.pagerduty.com/integration/${local.integration_key}/enqueue"
}

# Cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "pagerduty" {
  alarm_name                = "terraform-example-monitor"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  actions_enabled           = "true"
  alarm_actions             = [aws_sns_topic.pagerduty_noticiation.arn]
  ok_actions                = [aws_sns_topic.pagerduty_noticiation.arn]
  insufficient_data_actions = []
}
