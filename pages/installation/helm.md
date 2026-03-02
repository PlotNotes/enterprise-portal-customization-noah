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

<Prerequisites title="Before You Begin">

- Kubernetes 1.32+ cluster with kubectl access
- Helm 3.10+ installed
- Review the [System Requirements](/installation/requirements)

</Prerequisites>

{{#if terraform_modules.aws-infrastructure}}

<Tip>
**Using AWS?** Provision your infrastructure first with our [AWS Terraform module](/content/infrastructure/aws-infrastructure).
</Tip>

{{/if}}

---

<InstallStep stepNumber={1} title="Install Required Plugins">

Two `kubectl` plugins are required: **preflight** (for cluster validation) and **support-bundle** (for diagnostics).

<CommandBlock>
curl -fsSL https://krew.sh | bash
kubectl krew install preflight
kubectl krew install support-bundle
</CommandBlock>

</InstallStep>

<HelmInstallAssets stepNumber={2} />

<InstallStep stepNumber={3} title="Run Preflight Checks">

<Note>
**New in v3.0.0:** Preflight checks now run automatically during `helm install`. You can still run them manually:
</Note>

<CommandBlock command="helm template {{ app.slug }} oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} --values my-values.yaml | kubectl preflight -" />

</InstallStep>

<InstallStep stepNumber={4} title="Verify the Installation">

Check that all pods are running and services are available:

<CommandBlock>
kubectl -n {{ app.slug }} get pods
kubectl -n {{ app.slug }} get svc
helm list -n {{ app.slug }}
</CommandBlock>

Wait for all pods to reach `Running` state.

</InstallStep>

---

## Post-Installation Configuration

<Accordion title="Recommended Next Steps" defaultOpen={true}>

After your v3.0.0 Helm deployment is running:

1. **Configure Ingress** — Set up your ingress controller and TLS termination
2. **Create Values Override** — Save your `my-values.yaml` for future upgrades
3. **Set Up Monitoring** — v3.0.0 exposes Prometheus metrics automatically
4. **Configure Backups** — Use Velero or your preferred backup tool for PV snapshots

</Accordion>

## Troubleshooting

<Accordion title="Pod Startup Issues">

<CommandBlock>
kubectl -n {{ app.slug }} describe pod <pod-name>
kubectl -n {{ app.slug }} logs <pod-name>
kubectl -n {{ app.slug }} get events --sort-by='.lastTimestamp'
</CommandBlock>

</Accordion>

<Accordion title="Generate a Support Bundle">

<CommandBlock command="kubectl support-bundle --load-cluster-specs" />

Upload the bundle on the [Contact Support](/support/contact) page.

</Accordion>

## Next Steps

- [Post-Installation Guide](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
