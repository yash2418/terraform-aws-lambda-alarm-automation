output "create_lambda_function_arn" {
  description = "ARN of the create CloudWatch alarm Lambda function"
  value       = var.enable_creation ? aws_lambda_function.create_cw_alarm_lambda[0].arn : null
}

output "delete_lambda_function_arn" {
  description = "ARN of the delete CloudWatch alarm Lambda function"
  value       = var.enable_deletion ? aws_lambda_function.delete_cw_alarm_lambda[0].arn : null
}

output "create_lambda_function_name" {
  description = "Name of the create CloudWatch alarm Lambda function"
  value       = var.enable_creation ? aws_lambda_function.create_cw_alarm_lambda[0].function_name : null
}

output "delete_lambda_function_name" {
  description = "Name of the delete CloudWatch alarm Lambda function"
  value       = var.enable_deletion ? aws_lambda_function.delete_cw_alarm_lambda[0].function_name : null
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by Lambda functions"
  value       = aws_iam_role.lambda_role.arn
}

output "create_event_rule_arn" {
  description = "ARN of the CloudWatch event rule for creation"
  value       = var.enable_creation ? aws_cloudwatch_event_rule.lambda_create_rule[0].arn : null
}

output "delete_event_rule_arn" {
  description = "ARN of the CloudWatch event rule for deletion"
  value       = var.enable_deletion ? aws_cloudwatch_event_rule.lambda_delete_rule[0].arn : null
}

output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = aws_sns_topic.alarm_topic.arn
}

output "sns_topic_subscription_arn" {
  description = "ARN of the SNS topic subscription"
  value       = aws_sns_topic_subscription.email_notification.arn
} 