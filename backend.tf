terraform {
  backend "s3" {
    # Configure your S3 backend settings here
    # bucket = "your-terraform-state-bucket"
    # key    = "cloudwatch-alarms/terraform.tfstate"
    # region = "your-aws-region"
    
    # For local development, you can comment out the above and use local backend
    # or configure according to your organization's requirements
  }
} 