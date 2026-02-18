---
title: Database Configuration
description: Configure an external PostgreSQL database for {{ app.name }}
weight: 300
---

# Database Configuration

For production deployments, we recommend using an external PostgreSQL database.

## Supported Versions

- PostgreSQL 14, 15, 16

## Managed Database Services

{{#if entitlements.isAWSEnabled}}
### Amazon RDS

If you used our [AWS Terraform module](/infrastructure/aws-infrastructure), the database is already provisioned. Use the output connection string:

```bash
terraform output -raw database_connection_string
```
{{/if}}

{{#if entitlements.isGCPEnabled}}
### Google Cloud SQL

If you used our [GCP Terraform module](/infrastructure/gcp-infrastructure), use Cloud SQL Proxy for connectivity.
{{/if}}

{{#if entitlements.isAzureEnabled}}
### Azure Database for PostgreSQL

If you used our [Azure Terraform module](/infrastructure/azure-infrastructure), the database is already provisioned with private networking.
{{/if}}

## Configuration

```yaml
database:
  external: true
  uri: "postgresql://chartsmith:PASSWORD@HOST:5432/chartsmith?sslmode=require"
```

## Migration

To migrate from the embedded database to an external one:

1. Create a backup: `kubectl exec -n chartsmith deploy/chartsmith-postgresql -- pg_dump -U chartsmith > backup.sql`
2. Restore to external database: `psql -h HOST -U chartsmith < backup.sql`
3. Update the Helm values and upgrade
