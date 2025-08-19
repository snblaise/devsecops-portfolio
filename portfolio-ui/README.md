# CI/CD Pipeline with CloudFormation

A minimal CI/CD pipeline setup using AWS CodeCommit, CodeBuild, and CodePipeline.

## What's Included

- **CodeCommit Repository**: Git repository for source code
- **CodeBuild Project**: Builds and tests your application
- **CodePipeline**: Orchestrates the CI/CD workflow
- **S3 Bucket**: Stores build artifacts
- **IAM Roles**: Proper permissions for all services

## Quick Start

1. **Deploy the pipeline:**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

2. **Clone your new repository:**
   ```bash
   # Get the clone URL from the deployment output
   git clone <repository-clone-url>
   cd my-app
   ```

3. **Add your code and push:**
   ```bash
   # Add your application files
   echo '{"name": "my-app", "scripts": {"build": "echo Building...", "test": "echo Testing..."}}' > package.json
   
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

## Customization

- **Change project name**: Edit `PROJECT_NAME` in `deploy.sh`
- **Different branch**: Edit `BRANCH_NAME` in `deploy.sh`
- **Custom build steps**: Modify `buildspec.yml`

## Pipeline Flow

1. **Source**: Triggers on commits to main branch
2. **Build**: Runs `npm install`, `npm test`, `npm run build`
3. **Artifacts**: Stores build output in S3

## Clean Up

```bash
aws cloudformation delete-stack --stack-name cicd-pipeline-stack
```