# ChartSmith Enterprise Portal Content

This repository contains the custom Enterprise Portal content and Terraform infrastructure modules for ChartSmith.

## Structure

```
├── toc.yaml                    # Navigation structure & visibility rules
├── pages/                      # Markdown content pages
│   ├── getting-started.md
│   ├── installation/
│   ├── infrastructure/
│   ├── configuration/
│   ├── operations/
│   ├── reference/
│   └── support/
├── terraform/                  # Infrastructure-as-Code modules
│   ├── aws/                    # AWS: EKS + RDS + VPC
│   ├── gcp/                    # GCP: GKE + Cloud SQL + VPC
│   └── azure/                  # Azure: AKS + PostgreSQL + VNet
├── replicated/                 # Replicated manifests for TF module publishing
│   ├── terraform-aws.yaml
│   ├── terraform-gcp.yaml
│   └── terraform-azure.yaml
└── assets/                     # Images and diagrams
```

## How It Works

This repo is linked to the Replicated platform. When changes are pushed to `main`:

1. **Content pages** are synced and cached for rendering in the Enterprise Portal
2. **Terraform modules** are published to the Replicated Terraform Registry when a release is promoted

Content pages use Mustache-style templates with a rich context (customer, license, entitlements, channel, release) for personalized documentation.

## Content Authoring

Pages are Markdown with YAML frontmatter. See `toc.yaml` for the full navigation structure and visibility rules.

Template variables available in pages:
- `{{ app.name }}`, `{{ app.slug }}` — Application info
- `{{ customer.name }}`, `{{ customer.email }}` — Current customer
- `{{ license.id }}`, `{{ license.expiresAt }}` — License details
- `{{ entitlements.* }}` — License entitlements
- `{{ channel.name }}`, `{{ channel.slug }}` — Release channel
- `{{ release.version }}` — Current release version
- `{{ terraform_modules.* }}` — Available Terraform modules
- `{{#if condition}} ... {{/if}}` — Conditional blocks

## Terraform Modules

Customers consume modules via the Replicated Terraform Registry:

```hcl
module "chartsmith_aws" {
  source  = "proxy.replicated.com/chartsmith/aws-infrastructure/aws"
  version = "~> 1.0"
}
```

Authentication uses the same service account install token customers already use.
