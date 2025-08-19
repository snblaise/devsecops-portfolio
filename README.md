# DevSecOps Portfolio - Complete Deployment Guide

A production-ready DevSecOps portfolio showcasing secure cloud infrastructure, automated CI/CD pipelines, and modern web development practices. This project demonstrates enterprise-level security, compliance, and automation capabilities.

## 🏗️ Project Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           DevSecOps Portfolio Architecture                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────────┐  │
│  │   CI/CD         │    │  Infrastructure │    │      Portfolio UI           |  │
│  │   Pipelines     │───▶│     Stack       │───▶│                             │  │
│  │                 │    │                 │    │                             │  │
│  │ • Infrastructure│    │ • S3 + CloudFront│   │ • Next.js Application       │  │
│  │ • UI Deployment │    │ • WAF Security   │    │ • TypeScript + Tailwind    │  │
│  │ • Security Scans│    │ • Logging        │    │ • 3D Animations            │  │
│  │ • Automated     │    │ • Monitoring     │    │ • PWA Support              │  │
│  │   Testing       │    │                 │    │ • Security Headers          │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────────────────┘  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
devsecops-portfolio/
├── cicd-pipelines/                 # CI/CD automation and deployment scripts
├── portfolio-infra/                # AWS CloudFormation templates
├── portfolio-ui/                   # Next.js portfolio application
└── README.md                       # This file
```

## 🚀 Quick Start (5 Minutes)

### Prerequisites
- AWS CLI configured with appropriate permissions
- Node.js 18+ and npm installed
- Git configured
- **Manual S3 Bucket Creation Required**: Create an S3 bucket named `devsecoplogs` for logging

#### Create Logging Bucket
```bash
# Create the logging bucket manually (required before infrastructure deployment)
aws s3 mb s3://devsecoplogs --region us-east-1

# Enable versioning on the logging bucket
aws s3api put-bucket-versioning \
  --bucket devsecoplogs \
  --versioning-configuration Status=Enabled
```

### 1. Deploy Infrastructure & Pipelines
```bash
# Clone the project
git clone https://github.com/snblaise/devsecops-portfolio.git
cd devsecops-portfolio

# Deploy CI/CD pipelines first
cd cicd-pipelines
chmod +x deploy-infrastructure.sh deploy-ui-pipeline.sh
./deploy-infrastructure.sh
./deploy-ui-pipeline.sh

# Deploy infrastructure stack
cd ../portfolio-infra
aws cloudformation deploy \
  --template-file portfolio-infrastructure.yaml \
  --stack-name portfolio-infrastructure \
  --capabilities CAPABILITY_IAM
```

### 2. Deploy Application
```bash
# Setup and deploy UI
cd ../portfolio-ui
npm install
npm run build
npm test

# Push to trigger automated deployment
git add .
git commit -m "Initial deployment"
git push origin main
```

### 3. Access Your Portfolio
- Your portfolio will be available at the CloudFront URL from the stack outputs
- Monitor deployment progress in AWS CodePipeline console

## 📋 Detailed Deployment Guide

### Phase 1: Infrastructure Setup (10-15 minutes)

#### Step 1: Deploy CI/CD Pipelines
```bash
cd cicd-pipelines/
```

**Deploy Infrastructure Pipeline:**
```bash
./deploy-infrastructure.sh
```
This creates:
- CodeCommit repository for infrastructure code
- CodeBuild project with security scanning (Checkov)
- CodePipeline for automated infrastructure deployment
- IAM roles with least privilege access

**Deploy UI Pipeline:**
```bash
./deploy-ui-pipeline.sh
```
This creates:
- CodeCommit repository for UI code
- CodeBuild project with security auditing
- CodePipeline for automated UI deployment
- S3 bucket for build artifacts

#### Step 2: Deploy Core Infrastructure
```bash
cd ../portfolio-infra/
```

**Deploy WAF Stack (Security Layer):**
```bash
aws cloudformation deploy \
  --template-file waf-stack.yaml \
  --stack-name portfolio-waf \
  --capabilities CAPABILITY_IAM
```

**Deploy Main Infrastructure:**
```bash
# Ensure devsecoplogs bucket exists first
aws s3 ls s3://devsecoplogs || aws s3 mb s3://devsecoplogs

aws cloudformation deploy \
  --template-file portfolio-infrastructure.yaml \
  --stack-name portfolio-infrastructure \
  --capabilities CAPABILITY_IAM
```

This creates:
- S3 bucket for website hosting (private with OAC)
- CloudFront distribution with security headers
- WAF integration for DDoS protection
- Comprehensive logging and monitoring
- SSL/TLS encryption

### Phase 2: Application Deployment (5-10 minutes)

#### Step 3: Setup Development Environment
```bash
cd ../portfolio-ui/
```

**Install Dependencies:**
```bash
npm install
```

**Configure Environment:**
```bash
cp .env.example .env.local
# Edit .env.local with your specific configuration
```

**Setup Git Ignore (Important):**
```bash
# Create .gitignore file to exclude build artifacts and dependencies
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
/.pnp
.pnp.js

# Testing
/coverage

# Next.js
/.next/
/out/

# Production
/build

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env*.local

# Vercel
.vercel

# TypeScript
*.tsbuildinfo
next-env.d.ts
EOF
```

**Run Security Checks:**
```bash
npm run security-audit
npm run lint
npm run type-check
```

**Test Application:**
```bash
npm test
npm run build
```

#### Step 4: Deploy to Production
```bash
# Get repository URLs from pipeline deployment outputs
git remote add infrastructure <infrastructure-repo-url>
git remote add ui <ui-repo-url>

# Push infrastructure code
git subtree push --prefix=portfolio-infra infrastructure main

# Push UI code  
git subtree push --prefix=portfolio-ui ui main
```

### Phase 3: Verification & Monitoring (5 minutes)

#### Step 5: Verify Deployment
1. **Check Pipeline Status:**
   - Go to AWS CodePipeline console
   - Verify both pipelines completed successfully

2. **Test Website:**
   - Access CloudFront URL from stack outputs
   - Verify SSL certificate and security headers
   - Test responsive design and functionality

3. **Monitor Security:**
   - Check WAF metrics in CloudWatch
   - Review access logs in S3
   - Verify security scanning results in CodeBuild

## 🛡️ Security Features

### Infrastructure Security
- **WAF Protection**: DDoS protection, SQL injection, XSS prevention
- **Private S3 Buckets**: Origin Access Control (OAC) for CloudFront
- **SSL/TLS**: Minimum TLS 1.2, HTTPS redirect
- **Security Headers**: HSTS, CSP, X-Frame-Options
- **Access Logging**: Comprehensive audit trail

### CI/CD Security
- **SAST Scanning**: Checkov for infrastructure security
- **Dependency Scanning**: npm audit for vulnerabilities
- **Code Quality**: ESLint, TypeScript strict mode
- **Secrets Management**: No hardcoded credentials
- **Least Privilege**: Minimal IAM permissions

### Application Security
- **Content Security Policy**: XSS protection
- **Security Headers**: Comprehensive security headers
- **Input Validation**: Zod schema validation
- **PWA Security**: Secure service worker implementation

## 📊 Monitoring & Maintenance

### CloudWatch Dashboards
- Pipeline execution metrics
- Website performance metrics
- Security incident tracking
- Cost optimization insights

### Automated Alerts
- Pipeline failures
- Security scan failures
- High error rates
- Unusual traffic patterns

### Regular Maintenance Tasks
```bash
# Update dependencies monthly
npm update

# Security audit
npm run security-audit

# Infrastructure drift detection
aws cloudformation detect-stack-drift --stack-name portfolio-infrastructure
```

## 🔧 Customization Guide

### Branding & Content
1. **Update Portfolio Content:**
   - Edit `src/components/` for UI components
   - Modify `src/pages/` for page content
   - Update `public/assets/` for images and media

2. **Styling:**
   - Customize `tailwind.config.ts` for design system
   - Modify `src/styles/` for custom CSS

### Infrastructure Customization
1. **Domain Configuration:**
   - Add custom domain in CloudFront distribution
   - Configure Route 53 for DNS management
   - Add SSL certificate from ACM

2. **Security Enhancements:**
   - Customize WAF rules in `waf-stack.yaml`
   - Add additional security headers
   - Configure advanced monitoring

### CI/CD Customization
1. **Build Process:**
   - Modify `buildspec.yml` files
   - Add additional testing stages
   - Configure deployment environments

2. **Security Scanning:**
   - Add DAST scanning tools
   - Configure SIEM integration
   - Add compliance reporting

## 🚨 Troubleshooting

### Common Issues

**Pipeline Failures:**
```bash
# Check CodeBuild logs
aws logs describe-log-groups --log-group-name-prefix /aws/codebuild/

# View specific build logs
aws logs get-log-events --log-group-name <log-group> --log-stream-name <stream>
```

**CloudFront Issues:**
```bash
# Invalidate cache
aws cloudfront create-invalidation \
  --distribution-id <distribution-id> \
  --paths "/*"
```

**S3 Access Issues:**
```bash
# Check bucket policy
aws s3api get-bucket-policy --bucket <bucket-name>

# Verify OAC configuration
aws cloudfront get-origin-access-control --id <oac-id>
```

### Recovery Procedures

**Infrastructure Rollback:**
```bash
aws cloudformation cancel-update-stack --stack-name portfolio-infrastructure
```

**Application Rollback:**
```bash
# Revert to previous version in CodePipeline
aws codepipeline start-pipeline-execution --name <pipeline-name>
```

## 📈 Performance Optimization

### Build Optimization
- Next.js static export for optimal performance
- Image optimization with Sharp
- Bundle analysis and tree shaking
- PWA caching strategies

### Infrastructure Optimization
- CloudFront edge locations
- S3 transfer acceleration
- Gzip compression
- Browser caching headers

## 🎯 Next Steps

1. **Custom Domain Setup**
2. **Advanced Monitoring with Grafana**
3. **Multi-environment Deployment**
4. **Blue/Green Deployment Strategy**
5. **Advanced Security Scanning Integration**

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review AWS CloudFormation events
3. Check CodePipeline execution history
4. Review application logs in CloudWatch

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.