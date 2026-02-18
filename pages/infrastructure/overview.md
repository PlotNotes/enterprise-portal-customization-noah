---
title: Infrastructure Overview
description: Provision cloud infrastructure for {{ app.name }} using Terraform
weight: 100
---

# Infrastructure

{{ app.name }} provides Terraform modules to provision the cloud infrastructure required for production deployments. These modules create best-practice configurations for each cloud provider.

## Available Modules

{{#if terraform_modules.aws-infrastructure}}
### [AWS](/infrastructure/aws-infrastructure)
Provisions EKS, RDS (PostgreSQL), VPC, and all supporting resources.
{{/if}}

{{#if terraform_modules.gcp-infrastructure}}
### [Google Cloud](/infrastructure/gcp-infrastructure)
Provisions GKE, Cloud SQL (PostgreSQL), VPC, and all supporting resources.
{{/if}}

{{#if terraform_modules.azure-infrastructure}}
### [Azure](/infrastructure/azure-infrastructure)
Provisions AKS, Azure Database for PostgreSQL, VNet, and all supporting resources.
{{/if}}

## Getting Started with Terraform

### 1. Authenticate

```bash
terraform login proxy.replicated.com
```

When prompted, enter your service account install token (the same one used for `helm registry login`).

### 2. Reference a Module

```hcl
module "chartsmith_infra" {
  source  = "proxy.replicated.com/{{ app.slug }}/<MODULE_NAME>/<PROVIDER>"
  version = "~> {{ release.version }}"

  # Provider-specific configuration
  # See individual module pages for details
}
```

### 3. Apply

```bash
terraform init
terraform plan
terraform apply
```

## Architecture Pattern

All modules follow the same pattern:

```
┌─────────────────────────────────────────────┐
│              Cloud Provider                  │
│                                              │
│  ┌──────────┐  ┌───────────┐  ┌──────────┐ │
│  │   VPC /   │  │ Kubernetes │  │ Database │ │
│  │   VNet    │──│  Cluster   │──│ (PgSQL)  │ │
│  └──────────┘  └───────────┘  └──────────┘ │
│                      │                       │
│               ┌──────────────┐              │
│               │  ChartSmith  │              │
│               │  (Helm)      │              │
│               └──────────────┘              │
└─────────────────────────────────────────────┘
```

The Terraform module provisions the infrastructure, then you install {{ app.name }} via Helm into the created cluster. The module outputs include everything needed for the Helm install (cluster endpoint, database connection string, etc.).
