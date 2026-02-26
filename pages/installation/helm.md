---
title: Helm Installation
description: Install {{ app.name }} using Helm on your existing Kubernetes cluster
visible_when:
  entitlements:
    - isHelmInstallEnabled
weight: 200
install_type: helm
---

# Helm Installation (v1.0.0)

{{ app.name }} v1.0.0 deploys as a Helm chart via OCI registry through Replicated.

## Requirements

- Kubernetes cluster v1.26 or later
- Helm 3.x installed on your workstation
- kubectl configured with cluster access
- StorageClass available for persistent volumes

---

{{#if terraform_modules.aws-infrastructure}}
> **Using AWS?** Provision your infrastructure first with our [AWS Terraform module](/content/infrastructure/aws-infrastructure).
{{/if}}
{{#if terraform_modules.gcp-infrastructure}}
> **Using GCP?** Provision your infrastructure first with our [GCP Terraform module](/content/infrastructure/gcp-infrastructure).
{{/if}}
{{#if terraform_modules.azure-infrastructure}}
> **Using Azure?** Provision your infrastructure first with our [Azure Terraform module](/content/infrastructure/azure-infrastructure).
{{/if}}

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
