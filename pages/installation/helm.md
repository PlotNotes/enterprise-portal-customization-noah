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

<Prerequisites title="Requirements">

- Kubernetes 1.27+ cluster with kubectl access
- Helm 3.8+
- StorageClass available for persistent volumes

</Prerequisites>

{{#if terraform_modules.aws-infrastructure}}

<Tip>
**Using AWS?** Provision your infrastructure first with our [AWS Terraform module](/content/infrastructure/aws-infrastructure).
</Tip>

{{/if}}

---

<InstallStep stepNumber={1} title="Install Required Plugins">

Two `kubectl` plugins are required for validation and diagnostics:

<CommandBlock>
curl -fsSL https://krew.sh | bash
kubectl krew install preflight
kubectl krew install support-bundle
</CommandBlock>

</InstallStep>

<HelmInstallAssets stepNumber={2} />

<InstallStep stepNumber={3} title="Run Preflight Checks">

Validate your cluster meets the requirements:

<CommandBlock command="helm template {{ app.slug }} oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} --values my-values.yaml | kubectl preflight -" />

</InstallStep>

<InstallStep stepNumber={4} title="Verify the Installation">

<CommandBlock>
kubectl -n {{ app.slug }} get pods
kubectl -n {{ app.slug }} get svc
helm list -n {{ app.slug }}
</CommandBlock>

Wait for all pods to reach `Running` state.

</InstallStep>

<InstanceName />

---

## Post-Installation

After your v2.0.0 Helm deployment is running:

1. **Configure Ingress** — Set up your ingress controller and TLS
2. **Create Values Override** — Save your `my-values.yaml` for upgrades
3. **Configure Backups** — Set up PV snapshots with Velero

<Accordion title="Troubleshooting">

<CommandBlock>
kubectl -n {{ app.slug }} describe pod <pod-name>
kubectl -n {{ app.slug }} logs <pod-name>
kubectl support-bundle --load-cluster-specs
</CommandBlock>

</Accordion>

## Next Steps

- [Post-Installation Guide](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
