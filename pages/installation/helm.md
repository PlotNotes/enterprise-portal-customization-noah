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

```bash
curl -fsSL https://krew.sh | bash
kubectl krew install preflight
kubectl krew install support-bundle
```

---

<HelmConfiguration />

---

## Preflight Validation

> **New in v3.0.0:** Preflight checks now run automatically during `helm install`. You can still run them manually:

```bash
helm template {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --values my-values.yaml | kubectl preflight -
```

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

<PostInstall>

After your v3.0.0 Helm deployment is running:

1. **Configure Ingress** — Set up your ingress controller and TLS termination
2. **Create Values Override** — Save your `my-values.yaml` for future upgrades
3. **Set Up Monitoring** — v3.0.0 exposes Prometheus metrics automatically
4. **Configure Backups** — Use Velero or your preferred backup tool for PV snapshots

</PostInstall>

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
