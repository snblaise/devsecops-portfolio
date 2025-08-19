#!/bin/bash

# Deploy Infrastructure CI/CD Pipeline
STACK_NAME="devsecops-portfolio-infra-pipeline"
PROJECT_NAME="devsecops-portfolio"

echo "🏗️ Deploying Infrastructure CI/CD Pipeline..."

aws cloudformation deploy \
  --template-file infrastructure-pipeline.yaml \
  --stack-name $STACK_NAME \
  --parameter-overrides \
    ProjectName=$PROJECT_NAME \
  --capabilities CAPABILITY_IAM \
  --region us-east-1

if [ $? -eq 0 ]; then
  echo "✅ Infrastructure pipeline deployed successfully!"
  echo ""
  echo "📋 Getting pipeline information..."
  
  INFRA_REPO_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`InfraRepositoryUrl`].OutputValue' \
    --output text)
  
  GITHUB_CONNECTION_ARN=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`GitHubConnectionArn`].OutputValue' \
    --output text)
  
  INFRA_PIPELINE_NAME=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`InfraPipelineName`].OutputValue' \
    --output text)
  
  echo "📦 Infrastructure Repository: $INFRA_REPO_URL"
  echo "🔄 Pipeline Name: $INFRA_PIPELINE_NAME"
  echo "🔗 GitHub Connection ARN: $GITHUB_CONNECTION_ARN"
  echo ""
  echo "🔧 Next steps:"
  echo "1. Create GitHub repository: $INFRA_REPO_URL"
  echo "2. Complete GitHub connection setup in AWS Console:"
  echo "   - Go to CodePipeline > Settings > Connections"
  echo "   - Find the connection and click 'Update pending connection'"
  echo "   - Authorize with GitHub"
  echo "3. Add your infrastructure templates to the repository"
  echo "4. Push to main branch to trigger infrastructure deployment"
else
  echo "❌ Infrastructure pipeline deployment failed!"
  exit 1
fi