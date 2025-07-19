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
- Existing SNS topic stored in SSM Parameter Store

## Quick Start

1. **Configure variables in `terraform.tfvars`:**

```hcl
# Required
ssm_param_name = "/path/to/your/sns-topic-parameter"
aws_profile    = "your-aws-profile"
aws_region     = "your-aws-region"

# Optional
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
| ssm_param_name | SSM parameter containing SNS topic ARN | string |
| aws_region | AWS region for resources | string |

### Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| enable_creation | Enable alarm creation | true |
| enable_deletion | Enable alarm deletion | true |
| tags | Resource tags | {} |

## Alarm Details

- **Metric**: Lambda Errors
- **Threshold**: 20 errors in 5 minutes
- **Naming**: `{function-name}-lambda-alerts` 