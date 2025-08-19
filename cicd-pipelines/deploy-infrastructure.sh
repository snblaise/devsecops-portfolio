#!/bin/bash

#===============================================================================
# Infrastructure CI/CD Pipeline Deployment Script
#===============================================================================
# 
# Description: Deploys AWS CodePipeline infrastructure for automated 
#              CloudFormation template deployment with security scanning
#
# Prerequisites:
#   - AWS CLI configured with appropriate permissions
#   - IAM permissions for CloudFormation, CodePipeline, CodeBuild, S3, IAM
#   - GitHub account for repository creation
#
# Usage:
#   ./deploy-infrastructure.sh
#
# What this script creates:
#   - CodePipeline for infrastructure deployment
#   - CodeBuild project with Checkov security scanning
#   - S3 bucket for pipeline artifacts
#   - GitHub connection for source integration
#   - IAM roles with least privilege access
#
# Author: DevSecOps Team
# Version: 1.0
# Last Updated: $(date +%Y-%m-%d)
#===============================================================================

# Configuration
STACK_NAME="devsecops-portfolio-infra-pipeline"
PROJECT_NAME="devsecops-portfolio"
REGION="us-east-1"

# Validate prerequisites
echo "🔍 Validating prerequisites..."

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &>/dev/null; then
    echo "❌ AWS CLI not configured. Please run 'aws configure' first."
    exit 1
fi

# Check if template file exists
if [ ! -f "infrastructure-pipeline.yaml" ]; then
    echo "❌ Template file 'infrastructure-pipeline.yaml' not found."
    exit 1
fi

echo "✅ Prerequisites validated"
echo ""
echo "🏗️ Deploying Infrastructure CI/CD Pipeline..."
echo "   Stack Name: $STACK_NAME"
echo "   Project Name: $PROJECT_NAME"
echo "   Region: $REGION"
echo ""

# Deploy the CloudFormation stack
aws cloudformation deploy \
  --template-file infrastructure-pipeline.yaml \
  --stack-name $STACK_NAME \
  --parameter-overrides \
    ProjectName=$PROJECT_NAME \
  --capabilities CAPABILITY_IAM \
  --region $REGION

# Check deployment result
DEPLOYMENT_STATUS=$?

if [ $DEPLOYMENT_STATUS -eq 0 ]; then
  echo ""
  echo "✅ Infrastructure pipeline deployed successfully!"
  echo ""
  echo "📋 Getting pipeline information..."
  
  # Retrieve stack outputs
  INFRA_REPO_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`InfraRepositoryUrl`].OutputValue' \
    --output text \
    --region $REGION)
  
  GITHUB_CONNECTION_ARN=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`GitHubConnectionArn`].OutputValue' \
    --output text \
    --region $REGION)
  
  INFRA_PIPELINE_NAME=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`InfraPipelineName`].OutputValue' \
    --output text \
    --region $REGION)
  
  # Display deployment information
  echo "📦 Infrastructure Repository: $INFRA_REPO_URL"
  echo "🔄 Pipeline Name: $INFRA_PIPELINE_NAME"
  echo "🔗 GitHub Connection ARN: $GITHUB_CONNECTION_ARN"
  echo ""
  echo "🔧 Next steps:"
  echo "1. Create GitHub repository: $INFRA_REPO_URL"
  echo ""
  echo "2. Complete GitHub connection setup in AWS Console:"
  echo "   - Go to CodePipeline > Settings > Connections"
  echo "   - Find the connection and click 'Update pending connection'"
  echo "   - Authorize with GitHub"
  echo "3. Add your infrastructure templates to the repository"
  echo "4. Push to main branch to trigger infrastructure deployment"
  echo ""
  echo "📚 For troubleshooting, check:"
  echo "   - CloudFormation console: https://console.aws.amazon.com/cloudformation"
  echo "   - CodePipeline console: https://console.aws.amazon.com/codesuite/codepipeline"
  echo "   - Stack events for detailed error messages"
else
  echo ""
  echo "❌ Infrastructure pipeline deployment failed!"
  echo "📚 Troubleshooting steps:"
  echo "1. Check AWS CLI configuration: aws sts get-caller-identity"
  echo "2. Verify IAM permissions for CloudFormation, CodePipeline, CodeBuild"
  echo "3. Check CloudFormation events in AWS Console"
  echo "4. Ensure template file exists and is valid"
  echo "5. Check AWS service limits and quotas"
  exit 1
fi

#===============================================================================
# End of Script
#===============================================================================