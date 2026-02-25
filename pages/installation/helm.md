---
title: Helm Installation
description: Install {{ app.name }} using Helm on your existing Kubernetes cluster
visible_when:
  entitlements:
    - isHelmInstallEnabled
weight: 200
install_type: helm
---

# Helm Installation

{{ app.name }} deploys as a Helm chart via OCI registry through Replicated. This guide covers the installation procedure, preflight validation, and post-installation configuration.

<HelmRequirements />

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

## Install Required Plugins

Two `kubectl` plugins are required: **preflight** (for cluster validation) and **support-bundle** (for diagnostics).

Install the Krew plugin manager:

```bash
curl -fsSL https://krew.sh | bash
```

Install the plugins:

```bash
kubectl krew install preflight
kubectl krew install support-bundle
```

Verify the installations:

```bash
kubectl preflight version
kubectl support-bundle version
```

---

<HelmConfiguration />

---

## Preflight Validation

Before installing, validate that your cluster meets the requirements:

```bash
helm template {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --values my-values.yaml | kubectl preflight -
```

Preflight checks verify:

- Cluster resource availability
- Storage class configuration
- RBAC permissions
- Overall system requirements

---

<HelmInstallation />

<SupportLink />

---

### Verify the Installation

```bash
kubectl -n {{ app.slug }} get pods
kubectl -n {{ app.slug }} get svc
helm list -n {{ app.slug }}
```

Wait for all pods to reach `Running` state.

---

<InstanceName />

---

<PostInstall />

## Troubleshooting

### Pod Startup Issues

```bash
kubectl -n {{ app.slug }} describe pod <pod-name>
kubectl -n {{ app.slug }} logs <pod-name>
kubectl -n {{ app.slug }} get events --sort-by='.lastTimestamp'
```

### Generate a Support Bundle

```bash
kubectl support-bundle --load-cluster-specs
```

## Next Steps

- [Post-Installation Guide](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
