# ChartSmith Azure Infrastructure

This Terraform module provisions the Azure infrastructure required to run ChartSmith in production.

## What's Created

- **Resource Group** for all ChartSmith resources
- **VNet** with dedicated subnets for AKS and database
- **AKS Cluster** with autoscaling node pool
- **Azure Database for PostgreSQL Flexible Server** with private networking
- **Network Security Groups** with least-privilege rules

## Usage

```hcl
module "chartsmith_azure" {
  source  = "proxy.replicated.com/chartsmith/azure-infrastructure/azurerm"
  version = "~> 1.0"

  name       = "chartsmith-prod"
  location   = "eastus2"
  node_count = 3

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
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
- AzureRM provider >= 3.0
- Azure subscription with permissions to create AKS, PostgreSQL, and VNet resources
