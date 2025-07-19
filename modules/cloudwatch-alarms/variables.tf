variable "aws_profile" {
  type        = string
  description = "AWS profile to use for authentication"
}

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "your-aws-region"
}

variable "sns_topic_name" {
  type        = string
  description = "Name for the SNS topic for alarm notifications"
  default     = "cloudwatch-lambda-alarms"
}

variable "notification_email" {
  type        = string
  description = "Email address for alarm notifications"
}

variable "enable_creation" {
  type        = bool
  description = "Enable CloudWatch alarm creation functionality"
  default     = true
}

variable "enable_deletion" {
  type        = bool
  description = "Enable CloudWatch alarm deletion functionality"
  default     = true
}

variable "lambda_runtime" {
  type        = string
  description = "Lambda function runtime"
  default     = "python3.10"
}

variable "create_lambda_function_name" {
  type        = string
  description = "Name for the create CloudWatch alarm Lambda function"
  default     = "create-cloudwatch-alarm-function"
}

variable "delete_lambda_function_name" {
  type        = string
  description = "Name for the delete CloudWatch alarm Lambda function"
  default     = "delete-cloudwatch-alarm-function"
}

variable "create_event_rule_name" {
  type        = string
  description = "Name for the CloudWatch event rule for creation"
  default     = "cloudwatch-alarm-create-rule"
}

variable "delete_event_rule_name" {
  type        = string
  description = "Name for the CloudWatch event rule for deletion"
  default     = "cloudwatch-alarm-delete-rule"
}

variable "lambda_source_path" {
  type        = string
  description = "Path to Lambda function source code directory"
  default     = "lambda-functions"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
} 