output "create_lambda_function_arn" {
  description = "ARN of the create CloudWatch alarm Lambda function"
  value       = module.cloudwatch_alarms.create_lambda_function_arn
}

output "delete_lambda_function_arn" {
  description = "ARN of the delete CloudWatch alarm Lambda function"
  value       = module.cloudwatch_alarms.delete_lambda_function_arn
}

output "create_lambda_function_name" {
  description = "Name of the create CloudWatch alarm Lambda function"
  value       = module.cloudwatch_alarms.create_lambda_function_name
}

output "delete_lambda_function_name" {
  description = "Name of the delete CloudWatch alarm Lambda function"
  value       = module.cloudwatch_alarms.delete_lambda_function_name
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by Lambda functions"
  value       = module.cloudwatch_alarms.lambda_role_arn
}

output "create_event_rule_arn" {
  description = "ARN of the CloudWatch event rule for creation"
  value       = module.cloudwatch_alarms.create_event_rule_arn
}

output "delete_event_rule_arn" {
  description = "ARN of the CloudWatch event rule for deletion"
  value       = module.cloudwatch_alarms.delete_event_rule_arn
}

output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = module.cloudwatch_alarms.sns_topic_arn
}

output "sns_topic_subscription_arn" {
  description = "ARN of the SNS topic subscription"
  value       = module.cloudwatch_alarms.sns_topic_subscription_arn
} 