---
title: Configuration
description: Configure {{ app.name }} for your environment
weight: 100
---

# Configuration

{{ app.name }} is deployed as a Helm chart and configured through a `my-values.yaml` file. The chart includes PostgreSQL (internal or external), MinIO object storage (optional S3-compatible), background workers, web application infrastructure, secret management, multi-provider ingress support, and BuildKit service for container image building.

## Production Minimum Configuration

A production deployment requires at minimum:

<CommandBlock label="yaml" command="image:
  tag: &quot;your-version-tag&quot;

# External database (recommended)
postgresql:
  enabled: false

env:
  DB_HOST: &quot;your-db-host&quot;
  DB_PORT: &quot;5432&quot;
  DB_USER: &quot;{{ app.slug }}&quot;
  DB_NAME: &quot;{{ app.slug }}_production&quot;
  DB_NAME_CABLE: &quot;{{ app.slug }}_cable_production&quot;
  STORAGE_SERVICE: &quot;amazon&quot;
  AWS_REGION: &quot;us-west-2&quot;
  AWS_BUCKET: &quot;your-bucket-name&quot;
  APP_HOST: &quot;{{ app.slug }}.company.com&quot;
  AUTH_PROVIDER: &quot;entra_id&quot;

secrets:
  DB_PASSWORD: &quot;&quot;
  AWS_ACCESS_KEY_ID: &quot;&quot;
  AWS_SECRET_ACCESS_KEY: &quot;&quot;
  ENTRA_ID_CLIENT_ID: &quot;&quot;
  ENTRA_ID_CLIENT_SECRET: &quot;&quot;
  ENTRA_ID_TENANT_ID: &quot;&quot;

ingress:
  enabled: true
  hosts:
    - host: &quot;{{ app.slug }}.company.com&quot;
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: {{ app.slug }}-tls
      hosts:
        - &quot;{{ app.slug }}.company.com&quot;" />

> **Warning:** Never commit secrets to version control. Use CI/CD secret management or external secret stores for production environments.

---

## Database Configuration

### External PostgreSQL (Recommended)

Disable the internal database and configure your external connection:

<CommandBlock label="yaml" command="postgresql:
  enabled: false

env:
  DB_HOST: &quot;your-db-host&quot;
  DB_PORT: &quot;5432&quot;
  DB_USER: &quot;{{ app.slug }}&quot;
  DB_NAME: &quot;{{ app.slug }}_production&quot;
  DB_NAME_CABLE: &quot;{{ app.slug }}_cable_production&quot;

secrets:
  DB_PASSWORD: &quot;your-secure-password&quot;" />

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

<CommandBlock label="yaml" command="postgresql:
  enabled: true
  persistence:
    size: 20Gi
    storageClass: &quot;your-storage-class&quot;
  resources:
    limits:
      cpu: 2
      memory: 4Gi
    requests:
      cpu: 500m
      memory: 1Gi" />

---

## Object Storage Configuration

### External S3 (Recommended)

<CommandBlock label="yaml" command="env:
  STORAGE_SERVICE: &quot;amazon&quot;
  AWS_REGION: &quot;us-west-2&quot;
  AWS_BUCKET: &quot;your-bucket-name&quot;

secrets:
  AWS_ACCESS_KEY_ID: &quot;&quot;
  AWS_SECRET_ACCESS_KEY: &quot;&quot;" />

For S3-compatible services, add the endpoint:

<CommandBlock label="yaml" command="env:
  AWS_ENDPOINT: &quot;https://your-s3-compatible-endpoint&quot;" />

{{#if entitlements.isAzureEnabled}}
### Azure Blob Storage

<CommandBlock label="yaml" command="env:
  STORAGE_SERVICE: &quot;microsoft&quot;

secrets:
  AZURE_STORAGE_ACCOUNT_NAME: &quot;&quot;
  AZURE_STORAGE_ACCESS_KEY: &quot;&quot;" />
{{/if}}

### Internal MinIO (Development Only)

> **Note:** Internal MinIO is not intended for production use. Use an external S3-compatible storage service for production deployments.

<CommandBlock label="yaml" command="minio:
  enabled: true" />

---

## Secret Management

### Option A: Direct Values

Secrets provided directly in your values file are base64-encoded automatically. Some secrets like `SECRET_KEY_BASE` auto-generate and persist across upgrades if not explicitly set.

### Option B: External Secret Store

For enterprise deployments, integrate with an external secret store:

<CommandBlock label="yaml" command="externalSecret:
  enabled: true
  secretStore:
    name: your-secret-store
    kind: SecretStore" />

{{#if entitlements.isAWSEnabled}}
#### AWS Secrets Manager

<CommandBlock label="yaml" command="externalSecret:
  enabled: true
  secretStore:
    name: aws-secrets-manager
    kind: SecretStore
  aws:
    region: &quot;us-west-2&quot;
    role: &quot;arn:aws:iam::123456789012:role/{{ app.slug }}-secrets&quot;
    serviceAccount: &quot;{{ app.slug }}-sa&quot;" />
{{/if}}

{{#if entitlements.isAzureEnabled}}
#### Azure Key Vault

<CommandBlock label="yaml" command="externalSecret:
  enabled: true
  secretStore:
    name: azure-key-vault
    kind: SecretStore" />
{{/if}}

---

## Ingress and Networking

{{#if entitlements.isAWSEnabled}}
### AWS Application Load Balancer

<CommandBlock label="yaml" command="ingress:
  enabled: true
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/certificate-arn: &quot;arn:aws:acm:REGION:ACCOUNT:certificate/CERT_ID&quot;
    alb.ingress.kubernetes.io/ssl-policy: &quot;ELBSecurityPolicy-TLS-1-2-2017-01&quot;" />
{{/if}}

### NGINX Ingress Controller

<CommandBlock label="yaml" command="ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: &quot;true&quot;
    nginx.ingress.kubernetes.io/enable-cors: &quot;true&quot;
    nginx.ingress.kubernetes.io/affinity: &quot;cookie&quot;
    nginx.ingress.kubernetes.io/whitelist-source-range: &quot;10.0.0.0/8&quot;
  tls:
    - secretName: {{ app.slug }}-tls
      hosts:
        - &quot;{{ app.slug }}.company.com&quot;" />

### Application-Level TLS

For environments without ingress TLS termination, enable auto-generated self-signed certificates:

<CommandBlock label="yaml" command="env:
  USE_HTTPS: &quot;true&quot;

tls:
  autoGenerate: true
  validityDays: 365
  hosts:
    - &quot;{{ app.slug }}.company.com&quot;" />

### Manual Certificate Upload

Upload your PEM-encoded certificate as a Kubernetes secret:

<CommandBlock command="kubectl create secret tls {{ app.slug }}-tls \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key \
  -n {{ app.slug }}" />

### cert-manager

If you have cert-manager installed in your cluster:

<CommandBlock label="yaml" command="ingress:
  annotations:
    cert-manager.io/cluster-issuer: &quot;your-cluster-issuer&quot;
  tls:
    - secretName: {{ app.slug }}-tls
      hosts:
        - &quot;{{ app.slug }}.company.com&quot;" />

---

## Authentication

### Local Authentication

<CommandBlock label="yaml" command="env:
  AUTH_PROVIDER: &quot;local&quot;" />

### Microsoft Entra ID

Register an application in Azure AD with the redirect URI: `https://your-domain/auth/entra_id/callback`

<CommandBlock label="yaml" command="env:
  AUTH_PROVIDER: &quot;entra_id&quot;

secrets:
  ENTRA_ID_CLIENT_ID: &quot;&quot;
  ENTRA_ID_TENANT_ID: &quot;&quot;
  ENTRA_ID_CLIENT_SECRET: &quot;&quot;" />

### Okta

Create an OIDC web application in Okta with the redirect URI: `https://your-domain/auth/okta/callback`

<CommandBlock label="yaml" command="env:
  AUTH_PROVIDER: &quot;okta&quot;

secrets:
  OKTA_SITE: &quot;&quot;
  OKTA_CLIENT_ID: &quot;&quot;
  OKTA_AUTHORIZATION_SERVER: &quot;&quot;
  OKTA_AUDIENCE: &quot;&quot;" />

### WorkOS

Create an application in the WorkOS Dashboard with the redirect URI configured for your domain.

<CommandBlock label="yaml" command="env:
  AUTH_PROVIDER: &quot;workos&quot;

secrets:
  WORKOS_CLIENT_ID: &quot;&quot;
  WORKOS_AUTHKIT_DOMAIN: &quot;&quot;" />

### Keycloak

Create an OpenID Connect client in the Keycloak Admin Console with client authentication enabled, standard flow enabled, and the redirect URI: `https://your-domain/auth/keycloak/callback`

<CommandBlock label="yaml" command="env:
  AUTH_PROVIDER: &quot;keycloak&quot;
  KEYCLOAK_CLIENT_ID: &quot;&quot;
  KEYCLOAK_SITE: &quot;&quot;
  KEYCLOAK_REALM: &quot;&quot;
  KEYCLOAK_AUDIENCE: &quot;account&quot;

secrets:
  KEYCLOAK_CLIENT_SECRET: &quot;&quot;" />

Optional: For CLI authentication, create a separate public client with Device Authorization Grant flow and set `KEYCLOAK_DEVICE_AUTHORIZATION_CLIENT_ID`.

---

## Resource Sizing

<CommandBlock label="yaml" command="web:
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
      memory: 2Gi" />

> **Note:** Default resource requests are conservative. Increase them for production workloads.

{{#if entitlements.isHAEnabled}}
---

## High Availability

Production HA deployments should use:

<CommandBlock label="yaml" command="web:
  replicas: 3

worker:
  replicas: 3

terminationGracePeriodSeconds: 60" />

Use external HA-enabled services (e.g., AWS RDS Multi-AZ) and node selectors to distribute pods across availability zones:

<CommandBlock label="yaml" command="web:
  nodeSelector:
    topology.kubernetes.io/zone: &quot;&quot;
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule" />
{{/if}}

---

## Image Registry Configuration

### Replicated Proxy (Default)

Images are pulled from the Replicated proxy registry by default with automatic pull secret creation.

### Private Registry

Use `global.imageNamePrefixOverride` to redirect image pulls to your private registry:

<CommandBlock label="yaml" command="global:
  imageNamePrefixOverride: &quot;123456789012.dkr.ecr.us-west-2.amazonaws.com/{{ app.slug }}&quot;" />

This completely replaces the image path structure. For example:
- **Default:** `images.crewai.com/proxy/crewai/dockerhub/library/postgres:16`
- **Override:** `123456789012.dkr.ecr.us-west-2.amazonaws.com/{{ app.slug }}/postgres:16`

---

## BuildKit Security

Enable rootless mode for improved security:

<CommandBlock label="yaml" command="buildkit:
  rootless:
    enabled: true" />

Rootless mode runs as non-root (UID/GID 1000) with user namespace remapping and reduced attack surface. Requires Kubernetes nodes that allow `seccompProfile: Unconfined` and `appArmorProfile: Unconfined`.

> **Note:** Rootless mode may not be compatible with restrictive policies such as GKE Autopilot.

---

## Database Migrations

Migrations run automatically during installation and upgrades.

**Installation:** A setup Job runs `rails db:migrate`, seeds the database, and sets up default permissions.

**Upgrades:** A pre-upgrade Job runs migrations before the upgrade proceeds.

### Troubleshooting Migrations

<CommandBlock command="# View migration logs (upgrades)
kubectl logs -l app.kubernetes.io/component=migration --tail=100

# View setup logs (initial install)
kubectl logs -l app.kubernetes.io/component=setup --tail=100

# Check job status
kubectl get jobs -l app.kubernetes.io/component=migration" />

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

<CommandBlock label="yaml" command="postgresql:
  enabled: false
env:
  DB_HOST: &quot;your-rds-endpoint&quot;
  STORAGE_SERVICE: &quot;amazon&quot;
  AUTH_PROVIDER: &quot;entra_id&quot;
web:
  replicas: 3
ingress:
  enabled: true
  annotations:
    alb.ingress.kubernetes.io/certificate-arn: &quot;your-cert-arn&quot;
buildkit:
  enabled: true
externalSecret:
  enabled: true" />
{{/if}}

{{#if entitlements.isAzureEnabled}}
### Azure Production

<CommandBlock label="yaml" command="postgresql:
  enabled: false
env:
  DB_HOST: &quot;your-azure-db-endpoint&quot;
  STORAGE_SERVICE: &quot;microsoft&quot;
  AUTH_PROVIDER: &quot;entra_id&quot;
web:
  replicas: 3
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: &quot;true&quot;
externalSecret:
  enabled: true" />
{{/if}}

### Development / Testing

<CommandBlock label="yaml" command="postgresql:
  enabled: true
minio:
  enabled: true
env:
  AUTH_PROVIDER: &quot;local&quot;
  LOG_LEVEL: &quot;debug&quot;
  STORAGE_SERVICE: &quot;amazon&quot;
  AWS_ENDPOINT: &quot;http://{{ app.slug }}-minio:9000&quot;
web:
  replicas: 1
worker:
  replicas: 1
tls:
  autoGenerate: true" />
