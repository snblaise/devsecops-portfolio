# Enhanced DevSecOps Portfolio - AWS Architecture

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        CloudFront CDN                          │
│                    (Global Distribution)                       │
└─────────────────────┬───────────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────────┐
│                     S3 Static Website                          │
│              (Next.js Static Export)                           │
└─────────────────────┬───────────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────────┐
│                  API Gateway                                   │
│            (REST + WebSocket APIs)                             │
└─────┬─────────┬─────────┬─────────┬─────────┬─────────┬─────────┘
      │         │         │         │         │         │
      ▼         ▼         ▼         ▼         ▼         ▼
┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐
│Security │ │Metrics  │ │Threat   │ │Compliance│ │GitHub   │ │Chat     │
│Dashboard│ │Analytics│ │Intel    │ │Scanner  │ │Scanner  │ │Bot      │
│Lambda   │ │Lambda   │ │Lambda   │ │Lambda   │ │Lambda   │ │Lambda   │
└─────┬───┘ └─────┬───┘ └─────┬───┘ └─────┬───┘ └─────┬───┘ └─────┬───┘
      │           │           │           │           │           │
      ▼           ▼           ▼           ▼           ▼           ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DynamoDB                                  │
│        (Security Metrics, Scan Results, Chat History)         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    External Integrations                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   GitHub    │  │    AWS      │  │   Bedrock   │             │
│  │     API     │  │ Config/SSM  │  │     AI      │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

## AWS Services Required

### Core Infrastructure
- **CloudFront**: Global CDN for fast content delivery
- **S3**: Static website hosting + artifact storage
- **Route 53**: DNS management
- **Certificate Manager**: SSL/TLS certificates

### Backend Services
- **API Gateway**: REST APIs + WebSocket for real-time features
- **Lambda**: Serverless functions for all backend logic
- **DynamoDB**: NoSQL database for metrics and scan results
- **EventBridge**: Event-driven architecture

### Security & Monitoring
- **AWS Config**: Compliance monitoring
- **Systems Manager**: Parameter store for secrets
- **CloudWatch**: Logging and monitoring
- **X-Ray**: Distributed tracing

### AI/ML Services
- **Bedrock**: AI chatbot and recommendations
- **Rekognition**: Image analysis for architecture diagrams
- **Comprehend**: Natural language processing

### Integration Services
- **Secrets Manager**: API keys and tokens
- **SQS**: Message queuing for async processing
- **SNS**: Notifications

## Estimated Monthly Costs

| Service | Usage | Monthly Cost |
|---------|-------|--------------|
| CloudFront | 1TB transfer | $85 |
| S3 | 10GB storage + requests | $5 |
| Lambda | 1M requests/month | $20 |
| DynamoDB | 25GB + 1M reads/writes | $30 |
| API Gateway | 1M requests | $35 |
| Bedrock | 100K tokens/month | $50 |
| CloudWatch | Standard monitoring | $15 |
| Other services | Config, SSM, etc. | $25 |
| **Total** | | **~$265/month** |

## Deployment Strategy

### Phase 1: Core Infrastructure (Week 1)
- CDK stack for basic infrastructure
- Static site deployment pipeline
- Basic API Gateway + Lambda setup

### Phase 2: Security Features (Week 2-3)
- Security dashboard with real-time metrics
- GitHub integration for repository scanning
- Compliance monitoring dashboard

### Phase 3: Advanced Features (Week 3-4)
- AI chatbot integration
- Interactive architecture diagrams
- Threat intelligence feed

### Phase 4: Optimization (Week 4)
- Performance optimization
- Cost optimization
- Security hardening