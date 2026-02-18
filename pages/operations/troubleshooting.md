---
title: Troubleshooting
description: Common issues and solutions for {{ app.name }}
weight: 400
---

# Troubleshooting

## Common Issues

### Pods not starting

```bash
kubectl -n chartsmith get pods
kubectl -n chartsmith describe pod <POD_NAME>
kubectl -n chartsmith logs <POD_NAME>
```

### Database connection failed

1. Verify the connection string is correct
2. Check network connectivity to the database host
3. Verify the database user has appropriate permissions

### Registry authentication failed

Re-authenticate with the registry:

```bash
helm registry login registry.replicated.com \
  --username {{ customer.email }} \
  --password {{ license.id }}
```

### License expired

Your license expires on {{ license.expiresAt }}. Contact your account manager or [support](/support/contact) to renew.

## Support Bundles

Generate a support bundle for our team:

```bash
kubectl support-bundle --namespace chartsmith
```

Upload the bundle on the [Contact Support](/support/contact) page.

## Preflight Checks

Run preflight checks to validate your environment:

```bash
kubectl preflight --namespace chartsmith
```
