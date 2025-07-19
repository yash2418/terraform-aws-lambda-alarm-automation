module "cloudwatch_alarms" {
  source = "./modules/cloudwatch-alarms"

  aws_profile        = var.aws_profile
  aws_region         = var.aws_region
  sns_topic_name     = var.sns_topic_name
  notification_email = var.notification_email

  # Enable/disable creation and deletion functionality
  enable_creation = var.enable_creation
  enable_deletion = var.enable_deletion

  # Lambda function configuration
  lambda_runtime                = var.lambda_runtime
  create_lambda_function_name   = var.create_lambda_function_name
  delete_lambda_function_name   = var.delete_lambda_function_name
  lambda_source_path           = var.lambda_source_path

  # Event rule configuration
  create_event_rule_name = var.create_event_rule_name
  delete_event_rule_name = var.delete_event_rule_name

  # Tags
  tags = var.tags
} 