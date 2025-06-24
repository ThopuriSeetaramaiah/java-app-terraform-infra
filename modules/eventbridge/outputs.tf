output "event_bus_arn" {
  description = "ARN of the EventBridge event bus"
  value       = aws_cloudwatch_event_bus.main.arn
}

output "event_bus_name" {
  description = "Name of the EventBridge event bus"
  value       = aws_cloudwatch_event_bus.main.name
}

output "rule_arn" {
  description = "ARN of the scheduled task rule"
  value       = aws_cloudwatch_event_rule.scheduled_task.arn
}

output "custom_event_rule_arn" {
  description = "ARN of the custom event rule"
  value       = aws_cloudwatch_event_rule.custom_event.arn
}

output "events_put_policy_arn" {
  description = "ARN of the IAM policy for putting events on the bus"
  value       = aws_iam_policy.events_put_policy.arn
}
