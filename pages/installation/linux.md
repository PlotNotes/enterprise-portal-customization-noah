---
title: Linux Installation
description: Install {{ app.name }} on a Linux server with embedded Kubernetes
visible_when:
  entitlements:
    - isEmbeddedClusterDownloadEnabled
weight: 150
install_type: linux
---

# Linux Installation (v2.0.0)

Install {{ app.name }} v2.0.0 on a Linux server. This version includes improved cluster provisioning and faster install times.

<Prerequisites title="Requirements">

- Ubuntu 20.04+, RHEL 8+, or CentOS 8+
- 4 CPUs, 8GB RAM, 40GB disk minimum
- Root or sudo access
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

</Prerequisites>

{{#if entitlements.isHAEnabled}}

<Tip title="High Availability">
v2.0.0 includes improved multi-node support. After completing the single-node installation below, you can add worker nodes for redundancy.
</Tip>

{{/if}}

---

<LinuxInstallAssets stepNumber={1} />

<InstallStep stepNumber={2} title="Verify the Installation">

Check that all services are running:

<CommandBlock command="{{ app.slug }} status" />

Verify the admin console is accessible:

<CommandBlock command="curl -sk https://localhost:8800/api/v1/healthz" />

</InstallStep>

{{#if entitlements.isHAEnabled}}

<InstallStep stepNumber={3} title="Add Worker Nodes" optional={true}>

Generate a join token and run it on each additional node:

<CommandBlock command="{{ app.slug }} join-token" />

</InstallStep>

{{/if}}

<InstanceName />

---

## Post-Installation

After installation completes:

1. **TLS Certificates** — Set up HTTPS for the admin console
2. **Backup Schedule** — Configure automated backups
3. **Identity Provider** — Connect your SSO provider

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
