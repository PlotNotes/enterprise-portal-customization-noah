---
title: Helm Installation
description: Install {{ app.name }} using Helm on your existing Kubernetes cluster
visible_when:
  entitlements:
    - isHelmInstallEnabled
weight: 200
install_type: helm
---

# Helm Installation (v2.0.0)

{{ app.name }} v2.0.0 deploys as a Helm chart via OCI registry. This version includes updated chart defaults and improved resource management.

<HelmRequirements />

---

{{#if terraform_modules.aws-infrastructure}}
> **Using AWS?** Provision your infrastructure first with our [AWS Terraform module](/content/infrastructure/aws-infrastructure).
{{/if}}

## Install Required Plugins

```bash
curl -fsSL https://krew.sh | bash
kubectl krew install preflight
kubectl krew install support-bundle
```

---

<HelmConfiguration />

---

## Preflight Validation

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

---

<InstanceName />

---

<PostInstall>

After your v2.0.0 Helm deployment is running:

1. **Configure Ingress** — Set up your ingress controller and TLS
2. **Create Values Override** — Save your `my-values.yaml` for upgrades
3. **Configure Backups** — Set up PV snapshots with Velero

</PostInstall>

## Troubleshooting

```bash
kubectl -n {{ app.slug }} describe pod <pod-name>
kubectl -n {{ app.slug }} logs <pod-name>
kubectl support-bundle --load-cluster-specs
```

## Next Steps

- [Post-Installation Guide](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
