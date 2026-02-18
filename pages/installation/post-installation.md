---
title: Post-Installation
description: Steps to complete after installing {{ app.name }}
weight: 900
---

# Post-Installation

Complete these steps after installing {{ app.name }}.

## 1. Configure TLS

We strongly recommend configuring TLS certificates for production use. See the [TLS Configuration](/configuration/tls) guide.

## 2. Configure External Database

For production deployments, configure an external PostgreSQL database. See [Database Configuration](/configuration/database).

## 3. Set Up Monitoring

Configure metrics collection and alerting. See [Monitoring & Metrics](/operations/monitoring).

## 4. Configure Backups

Set up automated backups before going to production. See [Backup & Restore](/operations/backup).

## 5. DNS Configuration

Point your domain to the {{ app.name }} service:

```
{{ app.slug }}.yourdomain.com → <LOAD_BALANCER_IP>
```

## 6. Verify

Run the built-in preflight checks:

```bash
kubectl chartsmith preflight --namespace chartsmith
```

All checks should pass before proceeding to production use.
