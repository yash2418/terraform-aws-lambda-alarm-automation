# CloudWatch Alarms Automation

A Terraform module that automates CloudWatch alarm creation and deletion for AWS Lambda functions.

## Features

- **Automatic Alarm Creation**: Creates CloudWatch alarms when new Lambda functions are deployed
- **Automatic Alarm Deletion**: Removes alarms when Lambda functions are deleted
- **Configurable**: Enable/disable creation or deletion functionality independently
- **SNS Integration**: Uses existing SNS topic for notifications

## Requirements

- Terraform >= 1.5.0
- AWS CLI configured with appropriate credentials
- CloudTrail enabled in your AWS account
- Valid email address for alarm notifications

## Quick Start

1. **Configure variables in `terraform.tfvars`:**

```hcl
# Required
aws_profile        = "your-aws-profile"
aws_region         = "your-aws-region"
notification_email = "your-email@example.com"

# Optional
sns_topic_name  = "your-sns-topic-name"
enable_creation = true
enable_deletion = true

tags = {
  Environment = "your-environment"
  Project     = "your-project-name"
  Owner       = "your-team-name"
}
```

2. **Deploy:**

```bash
terraform init
terraform plan
terraform apply
```

## Configuration

### Required Variables

| Name | Description | Type |
|------|-------------|------|
| aws_profile | AWS profile for authentication | string |
| aws_region | AWS region for resources | string |
| notification_email | Email address for alarm notifications | string |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| sns_topic_name | Name for the SNS topic | cloudwatch-lambda-alarms |
| enable_creation | Enable alarm creation | true |
| enable_deletion | Enable alarm deletion | true |
| tags | Resource tags | {} |

## Alarm Details

- **Metric**: Lambda Errors
- **Threshold**: 20 errors in 5 minutes
- **Naming**: `{function-name}-lambda-alerts` 