# AWS Configuration
aws_profile        = "your-aws-profile"
aws_region         = "your-aws-region"

# SNS Configuration
sns_topic_name     = "your-sns-topic-name"
notification_email = "your-email@example.com"

# Feature Toggles
enable_creation = true
enable_deletion = true

# Lambda Configuration (Optional - defaults will be used if not specified)
# lambda_runtime                = "python3.10"
# create_lambda_function_name   = "your-create-function-name"
# delete_lambda_function_name   = "your-delete-function-name"
# lambda_source_path           = "lambda-functions"

# Event Rule Configuration (Optional - defaults will be used if not specified)
# create_event_rule_name = "your-create-event-rule-name"
# delete_event_rule_name = "your-delete-event-rule-name"

# Tags
tags = {
  Environment = "your-environment"
  Project     = "your-project-name"
  Owner       = "your-team-name"
} 