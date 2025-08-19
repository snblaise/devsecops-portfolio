#!/bin/bash

# Deploy UI CI/CD Pipeline
STACK_NAME="devsecops-portfolio-ui-pipeline"
PROJECT_NAME="devsecops-portfolio"
INFRASTRUCTURE_STACK_NAME="devsecops-portfolio-infrastructure"

echo "🎨 Deploying UI CI/CD Pipeline..."

aws cloudformation deploy \
  --template-file ui-pipeline.yaml \
  --stack-name $STACK_NAME \
  --parameter-overrides \
    ProjectName=$PROJECT_NAME \
    InfrastructureStackName=$INFRASTRUCTURE_STACK_NAME \
  --capabilities CAPABILITY_IAM \
  --region us-east-1

if [ $? -eq 0 ]; then
  echo "✅ UI pipeline deployed successfully!"
  echo ""
  echo "📋 Getting pipeline information..."
  
  UI_REPO_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`UIRepositoryUrl`].OutputValue' \
    --output text)
  
  GITHUB_CONNECTION_ARN=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`GitHubConnectionArn`].OutputValue' \
    --output text)
  
  UI_PIPELINE_NAME=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`UIPipelineName`].OutputValue' \
    --output text)
  
  echo "📦 UI Repository: $UI_REPO_URL"
  echo "🔄 Pipeline Name: $UI_PIPELINE_NAME"
  echo "🔗 GitHub Connection ARN: $GITHUB_CONNECTION_ARN"
  echo ""
  echo "🔧 Next steps:"
  echo "1. Create GitHub repository: $UI_REPO_URL"
  echo "2. Complete GitHub connection setup in AWS Console:"
  echo "   - Go to CodePipeline > Settings > Connections"
  echo "   - Find the connection and click 'Update pending connection'"
  echo "   - Authorize with GitHub"
  echo "3. Add your portfolio UI code to the repository"
  echo "4. Push to main branch to trigger UI deployment"
else
  echo "❌ UI pipeline deployment failed!"
  exit 1
fi