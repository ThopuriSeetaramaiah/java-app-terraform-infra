resource "aws_cloudwatch_event_bus" "main" {
  name = "${var.project}-${var.environment}-bus"

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = "${var.project}-${var.environment}-scheduled-task"
  description         = "Scheduled task for ${var.project} in ${var.environment}"
  schedule_expression = var.schedule_expression
  event_bus_name      = aws_cloudwatch_event_bus.main.name

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule           = aws_cloudwatch_event_rule.scheduled_task.name
  event_bus_name = aws_cloudwatch_event_bus.main.name
  target_id      = "lambda"
  arn            = var.lambda_arn

  input_transformer {
    input_paths = {
      time = "$.time"
    }
    input_template = <<EOF
{
  "time": <time>,
  "environment": "${var.environment}",
  "action": "process"
}
EOF
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_task.arn
}

# Custom event pattern rule
resource "aws_cloudwatch_event_rule" "custom_event" {
  name           = "${var.project}-${var.environment}-custom-event"
  description    = "Custom event rule for ${var.project} in ${var.environment}"
  event_bus_name = aws_cloudwatch_event_bus.main.name
  
  event_pattern = jsonencode({
    source      = ["${var.project}.${var.environment}"],
    detail-type = ["DataProcessingEvent"],
    detail = {
      status = ["STARTED", "COMPLETED", "FAILED"]
    }
  })

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_cloudwatch_event_target" "custom_event_lambda" {
  rule           = aws_cloudwatch_event_rule.custom_event.name
  event_bus_name = aws_cloudwatch_event_bus.main.name
  target_id      = "lambda"
  arn            = var.lambda_arn
}

# IAM Policy for putting events on the bus
resource "aws_iam_policy" "events_put_policy" {
  name        = "${var.project}-${var.environment}-events-put-policy"
  description = "Policy for putting events on the EventBridge bus"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "events:PutEvents"
        Effect   = "Allow"
        Resource = aws_cloudwatch_event_bus.main.arn
      }
    ]
  })
}
