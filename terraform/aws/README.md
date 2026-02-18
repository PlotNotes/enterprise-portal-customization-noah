# ChartSmith AWS Infrastructure

This Terraform module provisions the AWS infrastructure required to run ChartSmith in production.

## What's Created

- **VPC** with public and private subnets across 3 availability zones
- **EKS Cluster** with managed node group (autoscaling enabled)
- **RDS PostgreSQL** instance in a private subnet with automated backups
- **Security groups** with least-privilege network rules
- **IAM roles** for EKS and node group

## Usage

```hcl
module "chartsmith_aws" {
  source  = "proxy.replicated.com/chartsmith/aws-infrastructure/aws"
  version = "~> 1.0"

  name               = "chartsmith-prod"
  region             = "us-west-2"
  node_count         = 3
  db_instance_class  = "db.r6g.large"

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

2. Install ChartSmith via Helm using the outputs:

```bash
helm install chartsmith \
  oci://registry.replicated.com/chartsmith/stable/chartsmith \
  --namespace chartsmith --create-namespace \
  --set global.database.uri="$(terraform output -raw database_connection_string)" \
  --set license.id=<YOUR_LICENSE_ID>
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name` | Name prefix for all resources | `string` | `"chartsmith"` |
| `region` | AWS region | `string` | `"us-west-2"` |
| `vpc_cidr` | VPC CIDR block | `string` | `"10.0.0.0/16"` |
| `kubernetes_version` | EKS version | `string` | `"1.29"` |
| `node_instance_type` | EC2 instance type | `string` | `"m6i.xlarge"` |
| `node_count` | Desired node count | `number` | `3` |
| `node_max_count` | Max node count | `number` | `6` |
| `db_instance_class` | RDS instance class | `string` | `"db.r6g.large"` |
| `db_allocated_storage` | Storage in GB | `number` | `100` |
| `db_engine_version` | PostgreSQL version | `string` | `"15.4"` |
| `tags` | Resource tags | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_endpoint` | EKS cluster endpoint |
| `cluster_name` | EKS cluster name |
| `database_endpoint` | RDS endpoint |
| `database_connection_string` | Full connection string for Helm values |
| `vpc_id` | VPC ID |
| `kubeconfig_command` | Command to configure kubectl |

## Requirements

- Terraform >= 1.5.0
- AWS provider >= 5.0
- AWS credentials with permissions to create VPC, EKS, RDS, IAM resources
