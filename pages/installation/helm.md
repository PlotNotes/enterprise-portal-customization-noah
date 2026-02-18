---
title: Helm Installation
description: Install {{ app.name }} using Helm on your existing Kubernetes cluster
visible_when:
  entitlements:
    - isHelmInstallEnabled
weight: 200
---

# Helm Installation

{{ app.name }} deploys as a Helm chart via OCI registry through Replicated. This guide covers the installation procedure, preflight validation, and post-installation configuration.

## Prerequisites

- [System requirements](/installation/requirements) met
- `kubectl` access to your target cluster
- Helm 3.10+

{{#if terraform_modules.aws-infrastructure}}
> **Using AWS?** Provision your infrastructure first with our [AWS Terraform module](/infrastructure/aws-infrastructure).
{{/if}}
{{#if terraform_modules.gcp-infrastructure}}
> **Using GCP?** Provision your infrastructure first with our [GCP Terraform module](/infrastructure/gcp-infrastructure).
{{/if}}
{{#if terraform_modules.azure-infrastructure}}
> **Using Azure?** Provision your infrastructure first with our [Azure Terraform module](/infrastructure/azure-infrastructure).
{{/if}}

## Step 1: Registry Authentication

Obtain your registry credentials from the [customer portal](https://enterprise.crewai.com/crewai) using your customer email and secret token.

```bash
helm registry login registry.replicated.com \
  --username {{ customer.email }} \
  --password {{ license.id }}
```

## Step 2: Install Required Plugins

Two `kubectl` plugins are required: **preflight** (for cluster validation) and **support-bundle** (for diagnostics).

Install the Krew plugin manager:

```bash
curl -fsSL https://krew.sh | bash
```

Install the plugins:

```bash
kubectl krew install preflight
kubectl krew install support-bundle
```

Verify the installations:

```bash
kubectl preflight version
kubectl support-bundle version
```

## Step 3: Create Configuration File

Create a `my-values.yaml` file with your deployment settings. See the [Configuration Guide](/configuration/guide) for full details.

A minimum production configuration includes:

```yaml
# PostgreSQL - external database recommended
postgresql:
  enabled: false

# MinIO - external S3 recommended
minio:
  enabled: false

# Environment variables
env:
  APP_HOST: "{{ app.slug }}.example.com"
  DATABASE_URL: "postgresql://user:password@your-db-host:5432/{{ app.slug }}"
  STORAGE_SERVICE: "s3"
  STORAGE_BUCKET: "your-bucket-name"
  AUTH_PROVIDER: "entra_id"

# Secrets
secrets:
  DATABASE_PASSWORD: ""
  AWS_ACCESS_KEY_ID: ""
  AWS_SECRET_ACCESS_KEY: ""
  ENTRA_CLIENT_ID: ""
  ENTRA_CLIENT_SECRET: ""
  ENTRA_TENANT_ID: ""

# Web service
web:
  replicas: 2
  ingress:
    enabled: true
    hosts:
      - host: "{{ app.slug }}.example.com"
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: {{ app.slug }}-tls
        hosts:
          - "{{ app.slug }}.example.com"
```

> **Warning:** Never commit secrets to version control. Use CI/CD secret management or external secret stores for production environments.

## Step 4: Preflight Validation

Validate that your cluster meets the requirements before installing:

```bash
helm template {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --version {{ release.version }} \
  --values my-values.yaml | kubectl preflight -
```

Preflight checks verify:

- Cluster resource availability
- Storage class configuration
- RBAC permissions
- Overall system requirements

### Common Issues

**Missing default storage class:**

{{#if entitlements.isAWSEnabled}}
For EKS clusters:

```bash
kubectl patch storageclass gp2 \
  -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
```
{{/if}}

{{#if entitlements.isGCPEnabled}}
For GKE clusters:

```bash
kubectl patch storageclass standard \
  -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
```
{{/if}}

**Insufficient cluster resources:** Scale your node pool to meet the [minimum requirements](/installation/requirements).

## Step 5: Install the Chart

```bash
helm install {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --version {{ release.version }} \
  --namespace {{ app.slug }} \
  --create-namespace \
  --values my-values.yaml \
  --wait
```

{{#if entitlements.isHAEnabled}}
### High Availability Installation

For HA deployments, add the following to your `my-values.yaml`:

```yaml
replicas: 3
highAvailability:
  enabled: true
  database:
    external: true
    uri: <YOUR_DATABASE_URI>
```

See the [High Availability Guide](/configuration/high-availability) for full database and storage configuration.
{{/if}}

### Verify the Installation

```bash
# Check pod status
kubectl -n {{ app.slug }} get pods

# Review services
kubectl -n {{ app.slug }} get svc

# View installation logs
kubectl -n {{ app.slug }} logs -l app={{ app.slug }} --tail=100

# Verify chart version
helm list -n {{ app.slug }}
```

Wait for all pods to reach `Running` state.

> **Note:** If you see warnings about `RAILS_MASTER_KEY` during installation, remove it from your values file. The chart manages this configuration automatically.

## Step 6: Post-Installation Setup

After installation, complete the additional configuration steps in the [Post-Installation Guide](/installation/post-installation), including:

- Internal organization initialization
- Default permissions setup
- Application access configuration

## Troubleshooting

### Pod Startup Issues

```bash
# Describe pod status and events
kubectl -n {{ app.slug }} describe pod <pod-name>

# View pod logs
kubectl -n {{ app.slug }} logs <pod-name>

# Check recent events for image pull issues
kubectl -n {{ app.slug }} get events --sort-by='.lastTimestamp'
```

### Generate a Support Bundle

If you need to contact support, generate a support bundle:

```bash
kubectl support-bundle --load-cluster-specs
```

The output is saved as a compressed tar archive that can be shared with the support team.

## Next Steps

- [Post-Installation Guide](/installation/post-installation)
- [Configuration Guide](/configuration/guide) for production patterns
- [Troubleshooting](/operations/troubleshooting)
