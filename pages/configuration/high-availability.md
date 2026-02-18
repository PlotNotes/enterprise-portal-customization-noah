---
title: High Availability
description: Configure {{ app.name }} for high availability
visible_when:
  entitlements:
    - isHAEnabled
weight: 500
---

# High Availability

Deploy {{ app.name }} with redundancy across multiple nodes for production workloads.

## Requirements

- 3+ Kubernetes nodes (or Linux servers)
- External PostgreSQL database (embedded DB does not support HA)
- Shared storage (S3, GCS, or Azure Blob Storage)

## Helm Configuration

```yaml
replicas: 3

highAvailability:
  enabled: true

database:
  external: true
  uri: "postgresql://..."

storage:
  type: s3  # or gcs, azure
  bucket: chartsmith-charts
  region: us-west-2
```

## Architecture

In HA mode, {{ app.name }} runs 3 replicas behind a load balancer. All replicas share the external database and object storage. Any replica can serve any request.

```
                    Load Balancer
                    /     |     \
              Pod 1    Pod 2    Pod 3
                    \     |     /
              External PostgreSQL DB
                    \     |     /
                Object Storage (S3)
```

## Monitoring HA

Check replica health:

```bash
kubectl -n chartsmith get pods -l app=chartsmith
```

All pods should show `Running` with `1/1` ready containers.
