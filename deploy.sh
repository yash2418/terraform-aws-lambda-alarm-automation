#!/bin/bash

# CloudWatch Alarms Automation Deployment Script

echo "🚀 CloudWatch Alarms Automation Deployment"
echo "==========================================="

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform first."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install AWS CLI first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

if [ $? -ne 0 ]; then
    echo "❌ Terraform initialization failed"
    exit 1
fi

# Validate Terraform configuration
echo "🔍 Validating Terraform configuration..."
terraform validate

if [ $? -ne 0 ]; then
    echo "❌ Terraform validation failed"
    exit 1
fi

# Plan the deployment
echo "📋 Planning deployment..."
terraform plan

if [ $? -ne 0 ]; then
    echo "❌ Terraform plan failed"
    exit 1
fi

# Ask for confirmation
read -p "🤔 Do you want to apply these changes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Applying Terraform configuration..."
    terraform apply -auto-approve
    
    if [ $? -eq 0 ]; then
        echo "✅ Deployment completed successfully!"
        echo "📊 To view the outputs, run: terraform output"
    else
        echo "❌ Deployment failed"
        exit 1
    fi
else
    echo "🛑 Deployment cancelled"
fi 