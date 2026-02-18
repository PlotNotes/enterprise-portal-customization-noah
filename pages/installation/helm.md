---
title: Helm Installation
description: Install {{ app.name }} using Helm on your existing Kubernetes cluster
visible_when:
  entitlements:
    - isHelmInstallEnabled
weight: 200
---

# Helm Installation

Install {{ app.name }} on your existing Kubernetes cluster using Helm.

## Prerequisites

- [System requirements](/installation/requirements) met
- `kubectl` access to your target cluster
- Helm 3.12+

{{#if terraform_modules.aws-infrastructure}}
> **Using AWS?** Provision your infrastructure first with our [AWS Terraform module](/infrastructure/aws-infrastructure).
{{/if}}
{{#if terraform_modules.gcp-infrastructure}}
> **Using GCP?** Provision your infrastructure first with our [GCP Terraform module](/infrastructure/gcp-infrastructure).
{{/if}}
{{#if terraform_modules.azure-infrastructure}}
> **Using Azure?** Provision your infrastructure first with our [Azure Terraform module](/infrastructure/azure-infrastructure).
{{/if}}

## Step 1: Authenticate

```bash
helm registry login registry.replicated.com \
  --username {{ customer.email }} \
  --password {{ license.id }}
```

## Step 2: Create Namespace

```bash
kubectl create namespace chartsmith
```

## Step 3: Install

```bash
helm install {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --version {{ release.version }} \
  --namespace chartsmith \
  --set license.id={{ license.id }} \
  --set global.domain=chartsmith.example.com
```

{{#if entitlements.isHAEnabled}}
### High Availability Installation

For HA deployments, add the following values:

```bash
helm install {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --version {{ release.version }} \
  --namespace chartsmith \
  --set license.id={{ license.id }} \
  --set global.domain=chartsmith.example.com \
  --set replicas=3 \
  --set highAvailability.enabled=true \
  --set highAvailability.database.external=true \
  --set highAvailability.database.uri=<YOUR_DATABASE_URI>
```

See the [High Availability Guide](/configuration/high-availability) for database and storage configuration.
{{/if}}

## Step 4: Verify

```bash
kubectl -n chartsmith get pods
kubectl -n chartsmith get svc
```

Wait for all pods to reach `Running` state. This typically takes 2-5 minutes.

## Step 5: Access

Get the external URL:

```bash
kubectl -n chartsmith get ingress
```

Open the URL in your browser and log in with the admin credentials displayed during install.

## Next Steps

- [Post-Installation steps](/installation/post-installation)
- [Configuration Guide](/configuration/guide)
- [Helm Values Reference](/reference/helm-values)
