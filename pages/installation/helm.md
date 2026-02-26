---
title: Helm Installation
description: Install {{ app.name }} using Helm on your existing Kubernetes cluster
visible_when:
  entitlements:
    - isHelmInstallEnabled
weight: 200
install_type: helm
---

# Helm Installation (v3.0.0)

{{ app.name }} v3.0.0 deploys as a Helm chart via OCI registry. This latest version includes automatic preflight checks and simplified values configuration.

## Requirements

- Kubernetes cluster v1.28 or later
- Helm 3.x installed on your workstation
- kubectl configured with cluster access
- StorageClass available for persistent volumes

---

## Authenticate with the Registry

```bash
helm registry login registry.replicated.com \
  --username {{ customer.email }} \
  --password {{ license.id }}
```

---

## Install

```bash
helm install {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --namespace {{ app.slug }} \
  --create-namespace \
  --values my-values.yaml
```

> **New in v3.0.0:** Preflight checks now run automatically during `helm install`. No separate step needed.

---

## Verify

```bash
kubectl -n {{ app.slug }} get pods
kubectl -n {{ app.slug }} get svc
helm list -n {{ app.slug }}
```

Wait for all pods to reach `Running` state.

---

## Troubleshooting

```bash
kubectl -n {{ app.slug }} describe pod <pod-name>
kubectl -n {{ app.slug }} logs <pod-name>
kubectl support-bundle --load-cluster-specs
```

## Next Steps

- [Post-Installation Guide](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
