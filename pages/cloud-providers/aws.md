---
title: AWS
description: AWS-specific configuration for {{ app.name }} deployments on Amazon EKS
visible_when:
  entitlements:
    - isAWSEnabled
weight: 100
---

# AWS Integration

AWS-specific configuration for deploying {{ app.name }} on Amazon EKS.

## Prerequisites

- EKS cluster running Kubernetes 1.32.0+
- AWS CLI and `kubectl` configured
- Helm 3.10+
- Familiarity with RDS, S3, and ALB services

The following AWS components must be in place before deployment:

1. **EKS Cluster** (v1.32.0+)
2. **AWS Load Balancer Controller** for ALB ingress
3. **VPC and subnets** (public and private recommended)

---

## Amazon Aurora PostgreSQL

{{ app.name }} requires **PostgreSQL 16.8+** for production.

### Instance Sizing

| Environment | Instance | vCPU | RAM | Storage |
|-------------|----------|------|-----|---------|
| Development | db.t3.medium | 2 | 4 GiB | 50 GiB gp3 |
| Small Production | db.r6g.large | 2 | 16 GiB | 100 GiB gp3 |
| Medium Production | db.r6g.xlarge | 4 | 32 GiB | 250 GiB gp3 |
| Large Production | db.r6g.2xlarge | 8 | 64 GiB | 500 GiB gp3 |

Memory-optimized instances (R6g family) are recommended. Production workloads need gp3 storage with minimum 3000 IOPS.

### Network Connectivity

**Private Subnet (Recommended):**
- Place RDS in private subnets within the EKS VPC
- No internet exposure
- Security group permits PostgreSQL (5432) from the EKS node security group

**Public Access (Alternative):**
- Enable public accessibility on the RDS instance
- Security group allows traffic from EKS NAT gateway IPs
- Requires SSL/TLS enforcement with `sslmode=require`

### Helm Configuration

<CommandBlock label="yaml">
postgres:
  enabled: false

envVars:
  DB_HOST: "{{ app.slug }}-prod.cluster-abc123.us-east-1.rds.amazonaws.com"
  DB_PORT: "5432"
  DB_USER: "{{ app.slug }}"

secrets:
  DB_PASSWORD: "your-secure-password"
</CommandBlock>

---

## Amazon S3 Object Storage

{{ app.name }} uses S3 for crew artifacts, tool outputs, and user uploads.

### Bucket Setup

<CommandBlock>
aws s3api create-bucket \
  --bucket {{ app.slug }}-prod-storage \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket {{ app.slug }}-prod-storage \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket {{ app.slug }}-prod-storage \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
</CommandBlock>

### Authentication Methods

<OptionSelector label="S3 Auth Method" defaultOption="Pod Identity" storageKey="aws-s3-auth">
<Option value="Pod Identity">

Recommended for EKS 1.24+. No static keys required — credentials are provided automatically with rotation.

1. Create an IAM policy for S3 access (`GetObject`, `PutObject`, `DeleteObject`, `ListBucket`)
2. Create an IAM role with Pod Identity trust:

<CommandBlock>
aws iam create-role \
  --role-name CrewAIPodIdentityRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": ["sts:AssumeRole", "sts:TagSession"]
    }]
  }'

aws iam attach-role-policy \
  --role-name CrewAIPodIdentityRole \
  --policy-arn arn:aws:iam::ACCOUNT:policy/CrewAIS3Access
</CommandBlock>

3. Create the Pod Identity Association:

<CommandBlock>
aws eks create-pod-identity-association \
  --cluster-name your-cluster \
  --namespace {{ app.slug }} \
  --service-account default \
  --role-arn arn:aws:iam::ACCOUNT:role/CrewAIPodIdentityRole
</CommandBlock>

</Option>
<Option value="IRSA">

IAM Roles for Service Accounts (IRSA) uses an OIDC provider to map a Kubernetes service account to an IAM role.

1. Create an OIDC provider for your EKS cluster:

<CommandBlock>
eksctl utils associate-iam-oidc-provider \
  --cluster your-cluster \
  --approve
</CommandBlock>

2. Create a service account with the IAM role:

<CommandBlock>
eksctl create iamserviceaccount \
  --name {{ app.slug }}-sa \
  --namespace {{ app.slug }} \
  --cluster your-cluster \
  --role-name CrewAIIRSARole \
  --attach-policy-arn arn:aws:iam::ACCOUNT:policy/CrewAIS3Access \
  --approve
</CommandBlock>

3. Configure the Helm values to use the service account:

<CommandBlock label="yaml">
serviceAccount: "{{ app.slug }}-sa"

envVars:
  STORAGE_SERVICE: "amazon"
  AWS_REGION: "us-east-1"
  AWS_BUCKET: "{{ app.slug }}-prod-storage"
</CommandBlock>

</Option>
<Option value="Static Keys">

<Warning>
Static access keys are recommended for development only. Use Pod Identity or IRSA for production.
</Warning>

<CommandBlock label="yaml">
envVars:
  STORAGE_SERVICE: "amazon"
  AWS_REGION: "us-east-1"
  AWS_BUCKET: "{{ app.slug }}-prod-storage"

secrets:
  AWS_ACCESS_KEY_ID: "AKIAIOSFODNN7EXAMPLE"
  AWS_SECRET_ACCESS_KEY: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
</CommandBlock>

</Option>
</OptionSelector>

---

## Application Load Balancer

### Requirements

- Long-running requests (5+ minutes)
- WebSocket support for ActionCable persistent connections
- Stateless application (session affinity not required)

### Security Groups

| Component | Port | Source | Purpose |
|-----------|------|--------|---------|
| ALB (Ingress) | 443 | Allowed CIDRs | HTTPS traffic |
| ALB (Egress) | NodePort range | EKS workers | Backend traffic |
| EKS Workers (Ingress) | NodePort range | ALB security group | ALB health checks and traffic |

### ACM Certificate

<CommandBlock>
aws acm request-certificate \
  --domain-name {{ app.slug }}.your-company.com \
  --validation-method DNS \
  --region us-east-1
</CommandBlock>

---

## Amazon ECR Container Registry

{{ app.name }} builds and pushes crew automation container images to ECR.

### Requirements

- Repository URI **must end in** `/crewai-enterprise`
- Immutable tags **must be disabled** ({{ app.name }} overwrites tags for crew versions)
- Lifecycle policies recommended for managing old images

### Repository Setup

<CommandBlock>
aws ecr create-repository \
  --repository-name your-org/crewai-enterprise \
  --region us-east-1 \
  --image-scanning-configuration scanOnPush=true

aws ecr put-image-tag-mutability \
  --repository-name your-org/crewai-enterprise \
  --image-tag-mutability MUTABLE \
  --region us-east-1

aws ecr put-lifecycle-policy \
  --repository-name your-org/crewai-enterprise \
  --lifecycle-policy-text '{
    "rules": [{
      "rulePriority": 1,
      "description": "Remove untagged images after 7 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 7
      },
      "action": {"type": "expire"}
    }]
  }'
</CommandBlock>

### Valid Repository URIs

| URI | Valid |
|-----|-------|
| `123456789012.dkr.ecr.us-east-1.amazonaws.com/crewai-enterprise` | Yes |
| `123456789012.dkr.ecr.us-east-1.amazonaws.com/my-org/crewai-enterprise` | Yes |
| `123456789012.dkr.ecr.us-east-1.amazonaws.com/prod/crewai-enterprise` | Yes |
| `123456789012.dkr.ecr.us-east-1.amazonaws.com/crewai` | No |
| `123456789012.dkr.ecr.us-east-1.amazonaws.com/crewai-platform` | No |

### ECR IAM Policy

<CommandBlock label="json">
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ecr:GetAuthorizationToken"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "arn:aws:ecr:us-east-1:ACCOUNT:repository/*/crewai-enterprise"
    }
  ]
}
</CommandBlock>

### Helm Configuration for ECR

<CommandBlock label="yaml">
envVars:
  CREW_IMAGE_REGISTRY_OVERRIDE: "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-org"
  STORAGE_SERVICE: "amazon"
  AWS_REGION: "us-east-1"
  AWS_BUCKET: "{{ app.slug }}-prod-storage"

serviceAccount: "{{ app.slug }}-sa"

rbac:
  create: true
</CommandBlock>

---

## AWS Secrets Manager

### What to Store Where

**Store in Secrets Manager:**
`DB_PASSWORD`, `SECRET_KEY_BASE`, `ENTRA_ID_CLIENT_SECRET`, `OKTA_CLIENT_SECRET`, `AWS_SECRET_ACCESS_KEY`, `GITHUB_TOKEN`

**Keep in values.yaml:**
`DB_HOST`, `DB_PORT`, `DB_USER`, `POSTGRES_DB`, `POSTGRES_CABLE_DB`, `AWS_REGION`, `AWS_BUCKET`, `APPLICATION_HOST`, `AUTH_PROVIDER`

### Secret Structure

**Option 1 — Single Secret (JSON):**

Create a secret named `{{ app.slug }}/platform` containing all keys as a JSON document.

**Option 2 — Separate Secrets:**

Create individual secrets for each value (e.g., `{{ app.slug }}/db-password`, `{{ app.slug }}/secret-key-base`).

### External Secrets Operator

Install the External Secrets Operator:

<CommandBlock>
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets \
  external-secrets/external-secrets \
  --namespace external-secrets-operator \
  --create-namespace
</CommandBlock>

IAM policy for the operator:

<CommandBlock label="json">
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:us-east-1:ACCOUNT:secret:{{ app.slug }}/*"
    }
  ]
}
</CommandBlock>

### Helm Configuration

<CommandBlock label="yaml">
externalSecret:
  enabled: true
  secretStore: "{{ app.slug }}-secret-store"
  secretPath: "{{ app.slug }}/platform"
  includes_aws_credentials: false
  includes_azure_credentials: false

secretStore:
  enabled: true
  provider: "aws"
  aws:
    region: "us-east-1"
    auth:
      serviceAccount:
        enabled: true
        name: "{{ app.slug }}-secrets-reader"
</CommandBlock>

---

## Combined IAM Policy

A single policy granting S3 and ECR access:

<CommandBlock label="json">
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3Access",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::{{ app.slug }}-prod-storage",
        "arn:aws:s3:::{{ app.slug }}-prod-storage/*"
      ]
    },
    {
      "Sid": "ECRAuthToken",
      "Effect": "Allow",
      "Action": ["ecr:GetAuthorizationToken"],
      "Resource": "*"
    },
    {
      "Sid": "ECRPushPull",
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "arn:aws:ecr:us-east-1:ACCOUNT:repository/*/crewai-enterprise"
    }
  ]
}
</CommandBlock>

---

## Complete Production Configuration

<CommandBlock label="yaml">
postgres:
  enabled: false

minio:
  enabled: false

envVars:
  DB_HOST: "{{ app.slug }}-prod.cluster-abc123.us-east-1.rds.amazonaws.com"
  DB_PORT: "5432"
  DB_USER: "{{ app.slug }}"
  POSTGRES_DB: "{{ app.slug }}_plus_production"
  POSTGRES_CABLE_DB: "{{ app.slug }}_plus_cable_production"
  RAILS_MAX_THREADS: "5"
  DB_POOL: "5"
  STORAGE_SERVICE: "amazon"
  AWS_REGION: "us-east-1"
  AWS_BUCKET: "{{ app.slug }}-prod-storage"
  CREW_IMAGE_REGISTRY_OVERRIDE: "123456789012.dkr.ecr.us-east-1.amazonaws.com/production"
  APPLICATION_HOST: "{{ app.slug }}.company.com"
  AUTH_PROVIDER: "entra_id"
  RAILS_ENV: "production"
  RAILS_LOG_LEVEL: "info"

externalSecret:
  enabled: true
  secretStore: "{{ app.slug }}-secret-store"
  secretPath: "{{ app.slug }}/platform"
  includes_aws_credentials: false

secretStore:
  enabled: true
  provider: "aws"
  aws:
    region: "us-east-1"
    auth:
      serviceAccount:
        enabled: true
        name: "{{ app.slug }}-secrets-reader"

web:
  replicaCount: 3
  resources:
    requests:
      cpu: "1000m"
      memory: "6Gi"
    limits:
      cpu: "6"
      memory: "12Gi"
  ingress:
    enabled: true
    className: "alb"
    host: "{{ app.slug }}.company.com"
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
      alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS13-1-2-2021-06
      alb.ingress.kubernetes.io/ssl-redirect: "443"
      alb.ingress.kubernetes.io/target-group-attributes: idle_timeout.timeout_seconds=300
      alb.ingress.kubernetes.io/healthcheck-path: /up
      alb.ingress.kubernetes.io/tags: Environment=production,Application={{ app.slug }}
    alb:
      scheme: "internet-facing"
      targetType: "ip"
      certificateArn: "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"

worker:
  replicaCount: 3
  resources:
    requests:
      cpu: "1000m"
      memory: "6Gi"
    limits:
      cpu: "6"
      memory: "12Gi"

buildkit:
  enabled: true
  replicaCount: 1
  resources:
    requests:
      cpu: "500m"
      memory: "2Gi"
    limits:
      cpu: "4"
      memory: "8Gi"

rbac:
  create: true

serviceAccount: "{{ app.slug }}-sa"
</CommandBlock>

Deploy with:

<CommandBlock>
helm install {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --version {{ release.version }} \
  --values values-aws-production.yaml \
  --namespace {{ app.slug }}
</CommandBlock>

---

## Troubleshooting

### ALB Not Provisioning

- Check the AWS Load Balancer Controller is running
- Verify subnet tags: `kubernetes.io/role/elb=1` (public) or `kubernetes.io/role/internal-elb=1` (private)

### RDS Connection Timeout

- Verify security groups allow inbound PostgreSQL (5432) from EKS worker nodes
- Test connectivity from a pod:

<CommandBlock>
kubectl run -it --rm pg-test --image=postgres:16 --namespace {{ app.slug }} -- \
  psql "postgresql://{{ app.slug }}:PASSWORD@YOUR_RDS_ENDPOINT:5432/{{ app.slug }}_plus_production"
</CommandBlock>

### S3 Access Denied

- **Pod Identity:** Verify the EKS Pod Identity Agent daemonset is running and associations are listed
- **IRSA:** Check service account annotations and test with `aws s3 ls` from a pod
- **Static keys:** Confirm secrets exist in Kubernetes

### Secrets Manager Access Denied

<CommandBlock>
# Check ExternalSecret status
kubectl get externalsecret -n {{ app.slug }}

# Check SecretStore status
kubectl get secretstore -n {{ app.slug }}
</CommandBlock>

Verify the External Secrets Operator logs show successful role assumption and that the IAM role has the required Secrets Manager permissions.
