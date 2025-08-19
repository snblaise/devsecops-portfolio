# DevSecOps Portfolio CI/CD Pipelines

Enterprise-grade CI/CD pipelines implementing DevSecOps best practices with automated security scanning, infrastructure validation, and zero-downtime deployments.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           CI/CD Pipeline Architecture                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐  │
│  │  Infrastructure     │    │     UI Pipeline     │    │   Portfolio UI      │  │
│  │     Pipeline        │───▶│                     │───▶│                     │  │
│  │                     │    │                     │    │                     │  │
│  │ • CFN Validation    │    │ • Security Audit    │    │ • Next.js App       │  │
│  │ • Checkov SAST      │    │ • Unit Testing      │    │ • Static Export     │  │
│  │ • Drift Detection   │    │ • Type Checking     │    │ • S3 + CloudFront   │  │
│  │ • Rollback Safety   │    │ • Build & Deploy    │    │ • PWA Features      │  │
│  └─────────────────────┘    └─────────────────────┘    └─────────────────────┘  │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                          Security & Compliance Layer                       │  │
│  │                                                                             │  │
│  │ • SAST/DAST Scanning  • Dependency Auditing  • Compliance Reporting       │  │
│  │ • Secret Detection    • License Scanning     • Security Metrics           │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 📁 Pipeline Components

### Infrastructure Pipeline (`infrastructure-pipeline.yaml`)
- **Validation Stage**: CloudFormation linting, Checkov security scanning
- **Deploy Stage**: Infrastructure deployment with changeset creation
- **Rollback**: Automatic rollback on deployment failures
- **Security**: IAM least privilege, encrypted artifacts

### UI Pipeline (`ui-pipeline.yaml`)
- **Test Stage**: Security audit, linting, type checking, unit tests
- **Build Stage**: Next.js static export optimization
- **Deploy Stage**: S3 sync with backup, CloudFront invalidation
- **Blue/Green**: Backup creation before deployment

## 🚀 Quick Deployment (5 Minutes)

### Prerequisites
- AWS CLI configured with admin permissions
- Git configured with your credentials
- Bash shell (Linux/macOS/WSL)

### 1. Deploy Infrastructure Pipeline
```bash
# Make scripts executable
chmod +x deploy-infrastructure.sh deploy-ui-pipeline.sh

# Deploy infrastructure pipeline
./deploy-infrastructure.sh

# Expected output:
# ✅ Infrastructure pipeline deployed successfully
# 📋 Repository URL: https://git-codecommit.us-east-1.amazonaws.com/v1/repos/devsecops-portfolio-infrastructure
```

### 2. Deploy UI Pipeline
```bash
# Deploy UI pipeline
./deploy-ui-pipeline.sh

# Expected output:
# ✅ UI pipeline deployed successfully  
# 📋 Repository URL: https://git-codecommit.us-east-1.amazonaws.com/v1/repos/devsecops-portfolio-ui
```

### 3. Verify Deployment
```bash
# Check pipeline status
aws codepipeline list-pipelines --query 'pipelines[?contains(name, `devsecops-portfolio`)].name'

# Get repository clone URLs
aws codecommit get-repository --repository-name devsecops-portfolio-infrastructure --query 'repositoryMetadata.cloneUrlHttp'
aws codecommit get-repository --repository-name devsecops-portfolio-ui --query 'repositoryMetadata.cloneUrlHttp'
```

## 🔄 Pipeline Flow & Stages

### Infrastructure Pipeline (Security-First)

#### Stage 1: Source
- **Trigger**: CodeCommit push to `main` branch
- **Artifacts**: CloudFormation templates, configuration files
- **Security**: Encrypted artifact storage

#### Stage 2: Security Validation
```bash
# CloudFormation validation
aws cloudformation validate-template --template-body file://template.yaml

# Security scanning with Checkov
checkov -f template.yaml --framework cloudformation --check CKV_AWS_*

# Best practices validation
cfn-lint template.yaml
```

#### Stage 3: Deploy
- **Changeset Creation**: Review infrastructure changes
- **Deployment**: Automated with rollback protection
- **Verification**: Stack status and resource validation

### UI Pipeline (DevSecOps Integrated)

#### Stage 1: Source
- **Trigger**: CodeCommit push to `main` branch
- **Artifacts**: Next.js application code
- **Security**: Signed commits validation

#### Stage 2: Security & Quality
```bash
# Dependency vulnerability scanning
npm audit --audit-level high

# Code quality and security linting
npm run lint
npm run type-check

# Unit and integration tests
npm run test

# Security headers validation
npm run security-check
```

#### Stage 3: Build & Deploy
```bash
# Production build
npm run build

# Create deployment backup
aws s3 sync s3://website-bucket s3://backup-bucket --delete

# Deploy to S3
aws s3 sync ./out s3://website-bucket --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
```

## 🛡️ Security Features

### Infrastructure Security
- **SAST Scanning**: Checkov for CloudFormation security analysis
- **Compliance Checks**: CIS, NIST, PCI-DSS compliance validation
- **Drift Detection**: Automated infrastructure drift monitoring
- **IAM Least Privilege**: Role-based access with minimal permissions
- **Encrypted Storage**: All artifacts encrypted at rest and in transit
- **Audit Logging**: Comprehensive CloudTrail integration

### Application Security
- **Dependency Scanning**: npm audit with high-severity threshold
- **SAST Integration**: ESLint security rules and TypeScript strict mode
- **Secret Detection**: Automated scanning for hardcoded credentials
- **Security Headers**: CSP, HSTS, X-Frame-Options validation
- **License Compliance**: Automated license scanning and reporting
- **Container Scanning**: Docker image vulnerability assessment

### Pipeline Security
- **Secure Repositories**: Private CodeCommit with access controls
- **Encrypted Artifacts**: S3 KMS encryption for build artifacts
- **Role Separation**: Distinct IAM roles for each pipeline stage
- **Approval Gates**: Manual approval for production deployments
- **Rollback Automation**: Automatic rollback on security failures
- **Monitoring**: Real-time security event monitoring

## 📊 Production Best Practices

### Deployment Strategy
- **Blue/Green Deployments**: Zero-downtime deployments with instant rollback
- **Atomic Operations**: All-or-nothing deployment approach
- **Canary Releases**: Gradual traffic shifting for risk mitigation
- **Feature Flags**: Runtime configuration without deployments
- **Database Migrations**: Backward-compatible schema changes

### Monitoring & Observability
- **Real-time Metrics**: CloudWatch dashboards for pipeline health
- **Distributed Tracing**: X-Ray integration for request tracking
- **Log Aggregation**: Centralized logging with structured formats
- **Alerting**: PagerDuty integration for critical failures
- **SLA Monitoring**: Uptime and performance tracking

### Backup & Recovery
- **Automated Backups**: Pre-deployment snapshots
- **Point-in-time Recovery**: Database and file system backups
- **Cross-region Replication**: Disaster recovery preparation
- **Recovery Testing**: Regular disaster recovery drills
- **RTO/RPO Targets**: 15-minute recovery objectives

### Change Management
- **Infrastructure as Code**: All changes version controlled
- **Peer Review**: Mandatory code reviews for all changes
- **Changeset Approval**: Manual approval for infrastructure changes
- **Rollback Plans**: Automated and manual rollback procedures
- **Change Documentation**: Automated change logs and notifications

## 🔧 Configuration

### Environment Variables
```bash
# Core Configuration
export PROJECT_NAME="devsecops-portfolio"
export AWS_REGION="us-east-1"
export INFRASTRUCTURE_STACK_NAME="devsecops-portfolio-infrastructure"
export UI_STACK_NAME="devsecops-portfolio-ui"

# Security Configuration
export CHECKOV_VERSION="2.5.0"
export SECURITY_SCAN_THRESHOLD="HIGH"
export COMPLIANCE_FRAMEWORKS="CIS,NIST,PCI"

# Deployment Configuration
export DEPLOYMENT_TIMEOUT="30"
export ROLLBACK_ENABLED="true"
export BACKUP_RETENTION_DAYS="30"
```

### Required AWS Permissions

#### Infrastructure Pipeline Role
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:*",
        "s3:*",
        "cloudfront:*",
        "wafv2:*",
        "logs:*",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
```

#### UI Pipeline Role
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "cloudfront:CreateInvalidation",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:s3:::devsecops-portfolio-*",
        "arn:aws:s3:::devsecops-portfolio-*/*",
        "arn:aws:cloudfront::*:distribution/*",
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
```

## 📈 Monitoring & Alerts

### CloudWatch Dashboards

#### Pipeline Health Dashboard
```bash
# Create custom dashboard
aws cloudwatch put-dashboard --dashboard-name "DevSecOps-Pipeline-Health" --dashboard-body '{
  "widgets": [
    {
      "type": "metric",
      "properties": {
        "metrics": [
          ["AWS/CodePipeline", "PipelineExecutionSuccess", "PipelineName", "devsecops-portfolio-infrastructure"],
          ["AWS/CodePipeline", "PipelineExecutionFailure", "PipelineName", "devsecops-portfolio-infrastructure"]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "us-east-1",
        "title": "Pipeline Success/Failure Rate"
      }
    }
  ]
}'
```

### Automated Alerts

#### Critical Alerts (PagerDuty Integration)
```yaml
# CloudWatch Alarms
PipelineFailureAlarm:
  Type: AWS::CloudWatch::Alarm
  Properties:
    AlarmName: "DevSecOps-Pipeline-Failure"
    MetricName: "PipelineExecutionFailure"
    Namespace: "AWS/CodePipeline"
    Statistic: "Sum"
    Period: 300
    EvaluationPeriods: 1
    Threshold: 1
    ComparisonOperator: "GreaterThanOrEqualToThreshold"
    AlarmActions:
      - !Ref SNSTopicArn
```

## 🔄 Rollback Procedures

### Automated Rollback Triggers
- **Security Scan Failures**: Automatic rollback on high-severity findings
- **Health Check Failures**: Application health monitoring
- **Performance Degradation**: Response time threshold breaches
- **Error Rate Spikes**: 5xx error rate above 1%

### Infrastructure Rollback

#### Manual Rollback
```bash
# Cancel in-progress update
aws cloudformation cancel-update-stack --stack-name devsecops-portfolio-infrastructure

# Rollback to previous version
aws cloudformation continue-update-rollback --stack-name devsecops-portfolio-infrastructure

# Verify rollback completion
aws cloudformation describe-stacks --stack-name devsecops-portfolio-infrastructure --query 'Stacks[0].StackStatus'
```

### Application Rollback

#### Blue/Green Rollback
```bash
#!/bin/bash
# Automated rollback script

BUCKET_NAME="devsecops-portfolio-website"
BACKUP_BUCKET="devsecops-portfolio-backup"
DISTRIBUTION_ID=$(aws cloudformation describe-stacks --stack-name devsecops-portfolio-infrastructure --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDistributionId`].OutputValue' --output text)

echo "🔄 Starting rollback procedure..."

# 1. Create current state backup
echo "📦 Creating current state backup..."
aws s3 sync s3://$BUCKET_NAME s3://$BUCKET_NAME-emergency-backup --delete

# 2. Restore from backup
echo "🔙 Restoring from backup..."
aws s3 sync s3://$BACKUP_BUCKET s3://$BUCKET_NAME --delete

# 3. Invalidate CloudFront cache
echo "🗑️ Invalidating CloudFront cache..."
INVALIDATION_ID=$(aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*" --query 'Invalidation.Id' --output text)

# 4. Wait for invalidation completion
echo "⏳ Waiting for cache invalidation..."
aws cloudfront wait invalidation-completed --distribution-id $DISTRIBUTION_ID --id $INVALIDATION_ID

echo "✅ Rollback completed successfully"
```

## 🚨 Troubleshooting Guide

### Common Issues

#### Pipeline Deployment Failures

**Issue**: CloudFormation stack creation fails
```bash
# Check stack events
aws cloudformation describe-stack-events --stack-name devsecops-portfolio-cicd

# Common solutions:
# 1. IAM permissions insufficient
aws iam attach-user-policy --user-name $USER --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# 2. Resource limits exceeded
aws service-quotas get-service-quota --service-code cloudformation --quota-code L-0485CB21

# 3. Name conflicts - Update PROJECT_NAME in deployment scripts
```

**Issue**: CodeBuild project fails to start
```bash
# Check CodeBuild logs
aws logs describe-log-groups --log-group-name-prefix /aws/codebuild/devsecops-portfolio

# View specific build failure
aws codebuild batch-get-builds --ids $BUILD_ID
```

#### Security Scan Failures

**Issue**: Checkov security scan fails
```bash
# Run Checkov locally for debugging
pip install checkov
checkov -f infrastructure-template.yaml --framework cloudformation

# Common fixes:
# 1. Add encryption to S3 buckets
# 2. Enable versioning on S3 buckets
# 3. Add security groups to resources
# 4. Enable logging for services
```

**Issue**: npm audit finds vulnerabilities
```bash
# Fix automatically
npm audit fix

# Force fix breaking changes
npm audit fix --force

# Manual review and fix
npm audit
npm update package-name
```

### Recovery Procedures

#### Complete Pipeline Reset
```bash
#!/bin/bash
# Nuclear option - complete cleanup and redeploy

echo "🚨 Starting complete pipeline reset..."

# 1. Delete all stacks
aws cloudformation delete-stack --stack-name devsecops-portfolio-ui-pipeline
aws cloudformation delete-stack --stack-name devsecops-portfolio-infrastructure-pipeline

# 2. Wait for deletion
aws cloudformation wait stack-delete-complete --stack-name devsecops-portfolio-ui-pipeline
aws cloudformation wait stack-delete-complete --stack-name devsecops-portfolio-infrastructure-pipeline

# 3. Clean up orphaned resources
aws s3 rm s3://devsecops-portfolio-artifacts --recursive
aws s3 rb s3://devsecops-portfolio-artifacts

# 4. Redeploy
./deploy-infrastructure.sh
./deploy-ui-pipeline.sh

echo "✅ Pipeline reset completed"
```

## 🎯 Next Steps

### Immediate Actions (Next 30 minutes)
1. **Deploy Pipelines**: Run both deployment scripts
2. **Verify Setup**: Check pipeline status in AWS Console
3. **Clone Repositories**: Set up local development environment
4. **Initial Push**: Deploy infrastructure and application code
5. **Monitor Deployment**: Watch first automated deployment

### Short-term Enhancements (Next Week)
1. **Custom Domain**: Configure Route 53 and SSL certificate
2. **Advanced Monitoring**: Set up Grafana dashboards
3. **Security Hardening**: Implement additional WAF rules
4. **Performance Optimization**: Configure CloudFront caching
5. **Backup Strategy**: Implement cross-region backups

### Long-term Improvements (Next Month)
1. **Multi-Environment**: Staging and production environments
2. **Advanced Security**: SIEM integration and threat detection
3. **Compliance Automation**: SOC2, PCI-DSS reporting
4. **Disaster Recovery**: Multi-region deployment
5. **Cost Optimization**: Reserved instances and spot instances

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review AWS CloudFormation events
3. Check CodePipeline execution history
4. Review application logs in CloudWatch

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.