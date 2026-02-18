---
title: Backup & Restore
description: Backup and restore procedures for {{ app.name }}
weight: 200
---

# Backup & Restore

## What to Back Up

1. **Database** — PostgreSQL database containing chart metadata and user data
2. **Object Storage** — Chart packages stored in S3/GCS/Azure Blob

## Automated Backups

Enable automated database backups:

```yaml
backup:
  enabled: true
  schedule: "0 2 * * *"  # Daily at 2 AM
  retention: 30           # Keep 30 days
  destination:
    type: s3
    bucket: chartsmith-backups
    region: us-west-2
```

## Manual Backup

```bash
# Database
kubectl exec -n chartsmith deploy/chartsmith-postgresql -- \
  pg_dump -U chartsmith -Fc > chartsmith-$(date +%Y%m%d).dump

# Or with external database
pg_dump -h HOST -U chartsmith -Fc > chartsmith-$(date +%Y%m%d).dump
```

## Restore

```bash
# Stop the application
kubectl -n chartsmith scale deploy/chartsmith --replicas=0

# Restore database
pg_restore -h HOST -U chartsmith -d chartsmith chartsmith-20250209.dump

# Restart
kubectl -n chartsmith scale deploy/chartsmith --replicas=3
```
