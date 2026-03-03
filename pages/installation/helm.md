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

- Kubernetes 1.27+ cluster with kubectl access
- Helm 3.8+
- StorageClass available for persistent volumes

{{#if terraform_modules.aws-infrastructure}}
> **Using AWS?** Provision your infrastructure first with our [AWS Terraform module](/content/infrastructure/aws-infrastructure).
{{/if}}
{{#if terraform_modules.gcp-infrastructure}}
> **Using GCP?** Provision your infrastructure first with our [GCP Terraform module](/content/infrastructure/gcp-infrastructure).
{{/if}}
{{#if terraform_modules.azure-infrastructure}}
> **Using Azure?** Provision your infrastructure first with our [Azure Terraform module](/content/infrastructure/azure-infrastructure).
{{/if}}

---

## Step 1: Authenticate

```bash
helm registry login registry.replicated.com \
  --username {{ customer.email }} \
  --password <your-license-id>
```

You can find your license ID on the [License](/license) page.

---

## Step 2: Install the Chart

```bash
helm install {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --namespace {{ app.slug }} \
  --create-namespace
```

---

## Step 3: Verify

```bash
kubectl -n {{ app.slug }} get pods
kubectl -n {{ app.slug }} get svc
helm list -n {{ app.slug }}
```

Wait for all pods to reach `Running` state.

---

## Post-Installation

After installation:

1. Set up TLS certificates for your endpoints
2. Save your `my-values.yaml` for future upgrades

## Troubleshooting

```bash
kubectl -n {{ app.slug }} describe pod <pod-name>
kubectl -n {{ app.slug }} logs <pod-name>
kubectl support-bundle --load-cluster-specs
```

## Next Steps

- [Post-Installation Guide](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
