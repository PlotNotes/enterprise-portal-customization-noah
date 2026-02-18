# ChartSmith GCP Infrastructure

This Terraform module provisions the Google Cloud infrastructure required to run ChartSmith in production.

## What's Created

- **VPC** with private subnet and Cloud NAT
- **GKE Cluster** with autoscaling node pool
- **Cloud SQL PostgreSQL** instance with private networking
- **Firewall rules** with least-privilege access
- **Service accounts** for GKE workload identity

## Usage

```hcl
module "chartsmith_gcp" {
  source  = "proxy.replicated.com/chartsmith/gcp-infrastructure/google"
  version = "~> 1.0"

  name       = "chartsmith-prod"
  project_id = "my-gcp-project"
  region     = "us-central1"
  node_count = 1  # per zone (3 zones = 3 nodes)
}
```

## After Provisioning

1. Configure kubectl:

```bash
eval "$(terraform output -raw kubeconfig_command)"
```

2. Install ChartSmith via Helm.

## Requirements

- Terraform >= 1.5.0
- Google provider >= 5.0
- GCP project with Kubernetes Engine, Cloud SQL, and Compute APIs enabled
