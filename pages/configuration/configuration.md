---
title: Configuration
description: Configure {{ app.name }} for your environment
weight: 100
---

# Configuration

{{ app.name }} is deployed as a Helm chart and configured through a `my-values.yaml` file. The chart includes PostgreSQL (internal or external), MinIO object storage (optional S3-compatible), background workers, web application infrastructure, secret management, multi-provider ingress support, and BuildKit service for container image building.

## Production Minimum Configuration

A production deployment requires at minimum:

<CommandBlock label="yaml">
image:
  tag: "your-version-tag"

# External database (recommended)
postgresql:
  enabled: false

env:
  DB_HOST: "your-db-host"
  DB_PORT: "5432"
  DB_USER: "{{ app.slug }}"
  DB_NAME: "{{ app.slug }}_production"
  DB_NAME_CABLE: "{{ app.slug }}_cable_production"
  STORAGE_SERVICE: "amazon"
  AWS_REGION: "us-west-2"
  AWS_BUCKET: "your-bucket-name"
  APP_HOST: "{{ app.slug }}.company.com"
  AUTH_PROVIDER: "entra_id"

secrets:
  DB_PASSWORD: ""
  AWS_ACCESS_KEY_ID: ""
  AWS_SECRET_ACCESS_KEY: ""
  ENTRA_ID_CLIENT_ID: ""
  ENTRA_ID_CLIENT_SECRET: ""
  ENTRA_ID_TENANT_ID: ""

ingress:
  enabled: true
  hosts:
    - host: "{{ app.slug }}.company.com"
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: {{ app.slug }}-tls
      hosts:
        - "{{ app.slug }}.company.com"
</CommandBlock>

> **Warning:** Never commit secrets to version control. Use CI/CD secret management or external secret stores for production environments.

---

## Database Configuration

### External PostgreSQL (Recommended)

Disable the internal database and configure your external connection:

<CommandBlock label="yaml">
postgresql:
  enabled: false

env:
  DB_HOST: "your-db-host"
  DB_PORT: "5432"
  DB_USER: "{{ app.slug }}"
  DB_NAME: "{{ app.slug }}_production"
  DB_NAME_CABLE: "{{ app.slug }}_cable_production"

secrets:
  DB_PASSWORD: "your-secure-password"
</CommandBlock>

Supported version: **PostgreSQL 16.8+**

{{#if entitlements.isAWSEnabled}}
#### Amazon RDS

If you used our [AWS Terraform module](/infrastructure/aws-infrastructure), the database is already provisioned. Use the output connection string:

<CommandBlock command="terraform output -raw database_connection_string" />
{{/if}}

{{#if entitlements.isGCPEnabled}}
#### Google Cloud SQL

If you used our [GCP Terraform module](/infrastructure/gcp-infrastructure), use Cloud SQL Proxy for connectivity.
{{/if}}

{{#if entitlements.isAzureEnabled}}
#### Azure Database for PostgreSQL

If you used our [Azure Terraform module](/infrastructure/azure-infrastructure), the database is already provisioned with private networking.
{{/if}}

### Internal PostgreSQL (Development Only)

> **Warning:** Internal PostgreSQL is not intended for production use. It lacks high-availability features, automated backups, and enterprise-grade reliability. Always use an external managed PostgreSQL service for production deployments.

<CommandBlock label="yaml">
postgresql:
  enabled: true
  persistence:
    size: 20Gi
    storageClass: "your-storage-class"
  resources:
    limits:
      cpu: 2
      memory: 4Gi
    requests:
      cpu: 500m
      memory: 1Gi
</CommandBlock>

---

## Object Storage Configuration

### External S3 (Recommended)

<CommandBlock label="yaml">
env:
  STORAGE_SERVICE: "amazon"
  AWS_REGION: "us-west-2"
  AWS_BUCKET: "your-bucket-name"

secrets:
  AWS_ACCESS_KEY_ID: ""
  AWS_SECRET_ACCESS_KEY: ""
</CommandBlock>

For S3-compatible services, add the endpoint:

<CommandBlock label="yaml">
env:
  AWS_ENDPOINT: "https://your-s3-compatible-endpoint"
</CommandBlock>

{{#if entitlements.isAzureEnabled}}
### Azure Blob Storage

<CommandBlock label="yaml">
env:
  STORAGE_SERVICE: "microsoft"

secrets:
  AZURE_STORAGE_ACCOUNT_NAME: ""
  AZURE_STORAGE_ACCESS_KEY: ""
</CommandBlock>
{{/if}}

### Internal MinIO (Development Only)

> **Note:** Internal MinIO is not intended for production use. Use an external S3-compatible storage service for production deployments.

<CommandBlock label="yaml">
minio:
  enabled: true
</CommandBlock>

---

## Secret Management

### Option A: Direct Values

Secrets provided directly in your values file are base64-encoded automatically. Some secrets like `SECRET_KEY_BASE` auto-generate and persist across upgrades if not explicitly set.

### Option B: External Secret Store

For enterprise deployments, integrate with an external secret store:

<CommandBlock label="yaml">
externalSecret:
  enabled: true
  secretStore:
    name: your-secret-store
    kind: SecretStore
</CommandBlock>

{{#if entitlements.isAWSEnabled}}
#### AWS Secrets Manager

<CommandBlock label="yaml">
externalSecret:
  enabled: true
  secretStore:
    name: aws-secrets-manager
    kind: SecretStore
  aws:
    region: "us-west-2"
    role: "arn:aws:iam::123456789012:role/{{ app.slug }}-secrets"
    serviceAccount: "{{ app.slug }}-sa"
</CommandBlock>
{{/if}}

{{#if entitlements.isAzureEnabled}}
#### Azure Key Vault

<CommandBlock label="yaml">
externalSecret:
  enabled: true
  secretStore:
    name: azure-key-vault
    kind: SecretStore
</CommandBlock>
{{/if}}

---

## Ingress and Networking

{{#if entitlements.isAWSEnabled}}
### AWS Application Load Balancer

<CommandBlock label="yaml">
ingress:
  enabled: true
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:REGION:ACCOUNT:certificate/CERT_ID"
    alb.ingress.kubernetes.io/ssl-policy: "ELBSecurityPolicy-TLS-1-2-2017-01"
</CommandBlock>
{{/if}}

### NGINX Ingress Controller

<CommandBlock label="yaml">
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/whitelist-source-range: "10.0.0.0/8"
  tls:
    - secretName: {{ app.slug }}-tls
      hosts:
        - "{{ app.slug }}.company.com"
</CommandBlock>

### Application-Level TLS

For environments without ingress TLS termination, enable auto-generated self-signed certificates:

<CommandBlock label="yaml">
env:
  USE_HTTPS: "true"

tls:
  autoGenerate: true
  validityDays: 365
  hosts:
    - "{{ app.slug }}.company.com"
</CommandBlock>

### Manual Certificate Upload

Upload your PEM-encoded certificate as a Kubernetes secret:

<CommandBlock>
kubectl create secret tls {{ app.slug }}-tls \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key \
  -n {{ app.slug }}
</CommandBlock>

### cert-manager

If you have cert-manager installed in your cluster:

<CommandBlock label="yaml">
ingress:
  annotations:
    cert-manager.io/cluster-issuer: "your-cluster-issuer"
  tls:
    - secretName: {{ app.slug }}-tls
      hosts:
        - "{{ app.slug }}.company.com"
</CommandBlock>

---

## Authentication

### Local Authentication

<CommandBlock label="yaml">
env:
  AUTH_PROVIDER: "local"
</CommandBlock>

### Microsoft Entra ID

Register an application in Azure AD with the redirect URI: `https://your-domain/auth/entra_id/callback`

<CommandBlock label="yaml">
env:
  AUTH_PROVIDER: "entra_id"

secrets:
  ENTRA_ID_CLIENT_ID: ""
  ENTRA_ID_TENANT_ID: ""
  ENTRA_ID_CLIENT_SECRET: ""
</CommandBlock>

### Okta

Create an OIDC web application in Okta with the redirect URI: `https://your-domain/auth/okta/callback`

<CommandBlock label="yaml">
env:
  AUTH_PROVIDER: "okta"

secrets:
  OKTA_SITE: ""
  OKTA_CLIENT_ID: ""
  OKTA_AUTHORIZATION_SERVER: ""
  OKTA_AUDIENCE: ""
</CommandBlock>

### WorkOS

Create an application in the WorkOS Dashboard with the redirect URI configured for your domain.

<CommandBlock label="yaml">
env:
  AUTH_PROVIDER: "workos"

secrets:
  WORKOS_CLIENT_ID: ""
  WORKOS_AUTHKIT_DOMAIN: ""
</CommandBlock>

### Keycloak

Create an OpenID Connect client in the Keycloak Admin Console with client authentication enabled, standard flow enabled, and the redirect URI: `https://your-domain/auth/keycloak/callback`

<CommandBlock label="yaml">
env:
  AUTH_PROVIDER: "keycloak"
  KEYCLOAK_CLIENT_ID: ""
  KEYCLOAK_SITE: ""
  KEYCLOAK_REALM: ""
  KEYCLOAK_AUDIENCE: "account"

secrets:
  KEYCLOAK_CLIENT_SECRET: ""
</CommandBlock>

Optional: For CLI authentication, create a separate public client with Device Authorization Grant flow and set `KEYCLOAK_DEVICE_AUTHORIZATION_CLIENT_ID`.

---

## Resource Sizing

<CommandBlock label="yaml">
web:
  replicas: 2
  resources:
    limits:
      cpu: 6
      memory: 12Gi
    requests:
      cpu: 1000m
      memory: 6Gi

worker:
  replicas: 2
  resources:
    limits:
      cpu: 6
      memory: 12Gi
    requests:
      cpu: 1000m
      memory: 6Gi

buildkit:
  replicas: 1
  resources:
    limits:
      cpu: 4
      memory: 8Gi
    requests:
      cpu: 500m
      memory: 2Gi
</CommandBlock>

> **Note:** Default resource requests are conservative. Increase them for production workloads.

{{#if entitlements.isHAEnabled}}
---

## High Availability

Production HA deployments should use:

<CommandBlock label="yaml">
web:
  replicas: 3

worker:
  replicas: 3

terminationGracePeriodSeconds: 60
</CommandBlock>

Use external HA-enabled services (e.g., AWS RDS Multi-AZ) and node selectors to distribute pods across availability zones:

<CommandBlock label="yaml">
web:
  nodeSelector:
    topology.kubernetes.io/zone: ""
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
</CommandBlock>
{{/if}}

---

## Image Registry Configuration

### Replicated Proxy (Default)

Images are pulled from the Replicated proxy registry by default with automatic pull secret creation.

### Private Registry

Use `global.imageNamePrefixOverride` to redirect image pulls to your private registry:

<CommandBlock label="yaml">
global:
  imageNamePrefixOverride: "123456789012.dkr.ecr.us-west-2.amazonaws.com/{{ app.slug }}"
</CommandBlock>

This completely replaces the image path structure. For example:
- **Default:** `images.crewai.com/proxy/crewai/dockerhub/library/postgres:16`
- **Override:** `123456789012.dkr.ecr.us-west-2.amazonaws.com/{{ app.slug }}/postgres:16`

---

## BuildKit Security

Enable rootless mode for improved security:

<CommandBlock label="yaml">
buildkit:
  rootless:
    enabled: true
</CommandBlock>

Rootless mode runs as non-root (UID/GID 1000) with user namespace remapping and reduced attack surface. Requires Kubernetes nodes that allow `seccompProfile: Unconfined` and `appArmorProfile: Unconfined`.

> **Note:** Rootless mode may not be compatible with restrictive policies such as GKE Autopilot.

---

## Database Migrations

Migrations run automatically during installation and upgrades.

**Installation:** A setup Job runs `rails db:migrate`, seeds the database, and sets up default permissions.

**Upgrades:** A pre-upgrade Job runs migrations before the upgrade proceeds.

### Troubleshooting Migrations

<CommandBlock>
# View migration logs (upgrades)
kubectl logs -l app.kubernetes.io/component=migration --tail=100

# View setup logs (initial install)
kubectl logs -l app.kubernetes.io/component=setup --tail=100

# Check job status
kubectl get jobs -l app.kubernetes.io/component=migration
</CommandBlock>

---

## Security Best Practices

- **Secrets:** Use external secret stores for production; rotate secrets regularly
- **Network:** Enable TLS everywhere; configure ingress whitelists; use private subnets for databases
- **RBAC:** Create dedicated service accounts with minimal permissions
- **Database:** Use encrypted connections (SSL/TLS); enable audit logging
- **BuildKit:** Enable rootless mode where possible

---

## Common Deployment Scenarios

{{#if entitlements.isAWSEnabled}}
### AWS Production

<CommandBlock label="yaml">
postgresql:
  enabled: false
env:
  DB_HOST: "your-rds-endpoint"
  STORAGE_SERVICE: "amazon"
  AUTH_PROVIDER: "entra_id"
web:
  replicas: 3
ingress:
  enabled: true
  annotations:
    alb.ingress.kubernetes.io/certificate-arn: "your-cert-arn"
buildkit:
  enabled: true
externalSecret:
  enabled: true
</CommandBlock>
{{/if}}

{{#if entitlements.isAzureEnabled}}
### Azure Production

<CommandBlock label="yaml">
postgresql:
  enabled: false
env:
  DB_HOST: "your-azure-db-endpoint"
  STORAGE_SERVICE: "microsoft"
  AUTH_PROVIDER: "entra_id"
web:
  replicas: 3
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
externalSecret:
  enabled: true
</CommandBlock>
{{/if}}

### Development / Testing

<CommandBlock label="yaml">
postgresql:
  enabled: true
minio:
  enabled: true
env:
  AUTH_PROVIDER: "local"
  LOG_LEVEL: "debug"
  STORAGE_SERVICE: "amazon"
  AWS_ENDPOINT: "http://{{ app.slug }}-minio:9000"
web:
  replicas: 1
worker:
  replicas: 1
tls:
  autoGenerate: true
</CommandBlock>
