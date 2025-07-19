# SNS topic for CloudWatch alarm notifications
resource "aws_sns_topic" "alarm_topic" {
  name = var.sns_topic_name
  tags = var.tags
}

# SNS topic subscription for email notifications
resource "aws_sns_topic_subscription" "email_notification" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# IAM policy document for Lambda execution role
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_role" {
  name               = "cloudwatch-alarm-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags               = var.tags
}

# IAM policy for Lambda functions
resource "aws_iam_policy" "lambda_policy" {
  name        = "cloudwatch-alarm-lambda-policy"
  description = "Policy for CloudWatch alarm Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.alarm_topic.arn
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:GetFunction",
          "lambda:ListTags"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Archive file for create Lambda function
data "archive_file" "create_alarm_lambda" {
  count       = var.enable_creation ? 1 : 0
  type        = "zip"
  source_file = "${var.lambda_source_path}/create-cloudwatch-alarm-function/app.py"
  output_path = "${var.lambda_source_path}/create-cloudwatch-alarm-function.zip"
}

# Lambda function for creating CloudWatch alarms
resource "aws_lambda_function" "create_cw_alarm_lambda" {
  count            = var.enable_creation ? 1 : 0
  filename         = "${var.lambda_source_path}/create-cloudwatch-alarm-function.zip"
  function_name    = var.create_lambda_function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "app.lambda_handler"
  source_code_hash = data.archive_file.create_alarm_lambda[0].output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = 60

  environment {
    variables = {
      sns_topic = aws_sns_topic.alarm_topic.arn
    }
  }

  tags = var.tags
}

# Archive file for delete Lambda function
data "archive_file" "delete_alarm_lambda" {
  count       = var.enable_deletion ? 1 : 0
  type        = "zip"
  source_file = "${var.lambda_source_path}/delete-cloudwatch-alarm-function/app.py"
  output_path = "${var.lambda_source_path}/delete-cloudwatch-alarm-function.zip"
}

# Lambda function for deleting CloudWatch alarms
resource "aws_lambda_function" "delete_cw_alarm_lambda" {
  count            = var.enable_deletion ? 1 : 0
  filename         = "${var.lambda_source_path}/delete-cloudwatch-alarm-function.zip"
  function_name    = var.delete_lambda_function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "app.lambda_handler"
  source_code_hash = data.archive_file.delete_alarm_lambda[0].output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = 60

  tags = var.tags
}

# CloudWatch event rule for Lambda function creation (triggers alarm creation)
resource "aws_cloudwatch_event_rule" "lambda_create_rule" {
  count       = var.enable_creation ? 1 : 0
  name        = var.create_event_rule_name
  description = "Event rule to trigger Lambda on new Lambda function creation"
  
  event_pattern = jsonencode({
    "source" : ["aws.lambda"],
    "detail-type" : ["AWS API Call via CloudTrail"],
    "detail" : {
      "eventSource" : ["lambda.amazonaws.com"],
      "eventName" : ["CreateFunction20150331"]
    }
  })

  tags = var.tags
}

# CloudWatch event target for creation rule
resource "aws_cloudwatch_event_target" "lambda_create_target" {
  count          = var.enable_creation ? 1 : 0
  rule           = aws_cloudwatch_event_rule.lambda_create_rule[0].name
  event_bus_name = "default"
  arn            = aws_lambda_function.create_cw_alarm_lambda[0].arn
}

# Lambda permission for creation event rule
resource "aws_lambda_permission" "allow_cloudwatch_create" {
  count         = var.enable_creation ? 1 : 0
  statement_id  = "AllowExecutionFromEventbridgeCreate"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_cw_alarm_lambda[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_create_rule[0].arn
}

# CloudWatch event rule for Lambda function deletion (triggers alarm deletion)
resource "aws_cloudwatch_event_rule" "lambda_delete_rule" {
  count       = var.enable_deletion ? 1 : 0
  name        = var.delete_event_rule_name
  description = "Event rule to trigger Lambda on Lambda function deletion"
  
  event_pattern = jsonencode({
    "source" : ["aws.lambda"],
    "detail-type" : ["AWS API Call via CloudTrail"],
    "detail" : {
      "eventSource" : ["lambda.amazonaws.com"],
      "eventName" : ["DeleteFunction20150331"]
    }
  })

  tags = var.tags
}

# CloudWatch event target for deletion rule
resource "aws_cloudwatch_event_target" "lambda_delete_target" {
  count          = var.enable_deletion ? 1 : 0
  rule           = aws_cloudwatch_event_rule.lambda_delete_rule[0].name
  event_bus_name = "default"
  arn            = aws_lambda_function.delete_cw_alarm_lambda[0].arn
}

# Lambda permission for deletion event rule
resource "aws_lambda_permission" "allow_cloudwatch_delete" {
  count         = var.enable_deletion ? 1 : 0
  statement_id  = "AllowExecutionFromEventbridgeDelete"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_cw_alarm_lambda[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_delete_rule[0].arn
} 
