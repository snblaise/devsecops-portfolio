#!/bin/bash

#===============================================================================
# UI CI/CD Pipeline Deployment Script
#===============================================================================
# 
# Description: Deploys AWS CodePipeline for automated UI deployment with
#              testing, building, and CloudFront invalidation
#
# Prerequisites:
#   - AWS CLI configured with appropriate permissions
#   - Infrastructure pipeline already deployed
#   - IAM permissions for CodePipeline, CodeBuild, S3, CloudFront
#   - GitHub account for repository creation
#
# Usage:
#   ./deploy-ui-pipeline.sh
#
# What this script creates:
#   - CodePipeline for UI deployment
#   - CodeBuild projects for testing and building
#   - S3 bucket for pipeline artifacts
#   - GitHub connection for source integration
#   - CloudFront invalidation automation
#
# Author: DevSecOps Team
# Version: 1.0
# Last Updated: $(date +%Y-%m-%d)
#===============================================================================

# Configuration
STACK_NAME="devsecops-portfolio-ui-pipeline"
PROJECT_NAME="devsecops-portfolio"
INFRASTRUCTURE_STACK_NAME="devsecops-portfolio-infrastructure"
REGION="us-east-1"

# Validate prerequisites
echo "🔍 Validating prerequisites..."

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &>/dev/null; then
    echo "❌ AWS CLI not configured. Please run 'aws configure' first."
    exit 1
fi

# Check if template file exists
if [ ! -f "ui-pipeline.yaml" ]; then
    echo "❌ Template file 'ui-pipeline.yaml' not found."
    exit 1
fi

# Check if infrastructure stack exists
if ! aws cloudformation describe-stacks --stack-name $INFRASTRUCTURE_STACK_NAME --region $REGION &>/dev/null; then
    echo "⚠️  Warning: Infrastructure stack '$INFRASTRUCTURE_STACK_NAME' not found."
    echo "   The UI pipeline will still deploy but may need manual configuration."
fi

echo "✅ Prerequisites validated"
echo ""
echo "🎨 Deploying UI CI/CD Pipeline..."
echo "   Stack Name: $STACK_NAME"
echo "   Project Name: $PROJECT_NAME"
echo "   Infrastructure Stack: $INFRASTRUCTURE_STACK_NAME"
echo "   Region: $REGION"
echo ""

# Deploy the CloudFormation stack
aws cloudformation deploy \
  --template-file ui-pipeline.yaml \
  --stack-name $STACK_NAME \
  --parameter-overrides \
    ProjectName=$PROJECT_NAME \
    InfrastructureStackName=$INFRASTRUCTURE_STACK_NAME \
  --capabilities CAPABILITY_IAM \
  --region $REGION

# Check deployment result
DEPLOYMENT_STATUS=$?

if [ $DEPLOYMENT_STATUS -eq 0 ]; then
  echo ""
  echo "✅ UI pipeline deployed successfully!"
  echo ""
  echo "📋 Getting pipeline information..."
  
  # Retrieve stack outputs
  UI_REPO_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`UIRepositoryUrl`].OutputValue' \
    --output text \
    --region $REGION)
  
  GITHUB_CONNECTION_ARN=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`GitHubConnectionArn`].OutputValue' \
    --output text \
    --region $REGION)
  
  UI_PIPELINE_NAME=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`UIPipelineName`].OutputValue' \
    --output text \
    --region $REGION)
  
  # Display deployment information
  echo "📦 UI Repository: $UI_REPO_URL"
  echo "🔄 Pipeline Name: $UI_PIPELINE_NAME"
  echo "🔗 GitHub Connection ARN: $GITHUB_CONNECTION_ARN"
  echo ""
  echo "🔧 Next steps:"
  echo "1. Create GitHub repository: $UI_REPO_URL"
  echo ""
  echo "2. Complete GitHub connection setup in AWS Console:"
  echo "   - Go to CodePipeline > Settings > Connections"
  echo "   - Find the connection and click 'Update pending connection'"
  echo "   - Authorize with GitHub"
  echo "3. Add your portfolio UI code to the repository"
  echo "4. Push to main branch to trigger UI deployment"
  echo ""
  echo "📋 Pipeline stages:"
  echo "   - Source: Pull code from GitHub"
  echo "   - Test: Run linting, type checking, and unit tests"
  echo "   - Build: Create production build with Next.js"
  echo "   - Deploy: Upload to S3 and invalidate CloudFront cache"
  echo ""
  echo "📚 For troubleshooting, check:"
  echo "   - CodePipeline console: https://console.aws.amazon.com/codesuite/codepipeline"
  echo "   - CodeBuild logs for build failures"
  echo "   - S3 bucket permissions for deployment issues"
  echo "   - CloudFront distribution configuration"
else
  echo ""
  echo "❌ UI pipeline deployment failed!"
  echo "📚 Troubleshooting steps:"
  echo "1. Check AWS CLI configuration: aws sts get-caller-identity"
  echo "2. Verify IAM permissions for CodePipeline, CodeBuild, S3, CloudFront"
  echo "3. Ensure infrastructure stack exists and is in CREATE_COMPLETE status"
  echo "4. Check CloudFormation events in AWS Console"
  echo "5. Verify template file exists and is valid"
  echo "6. Check AWS service limits and quotas"
  exit 1
fi

#===============================================================================
# End of Script
#===============================================================================