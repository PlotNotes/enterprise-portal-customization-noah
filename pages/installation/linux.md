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

<LinuxRequirements />

---

## Before You Begin

- Have root or sudo access ready
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

{{#if entitlements.isHAEnabled}}
> **High Availability:** v2.0.0 includes improved multi-node support. After completing the single-node installation below, you can add worker nodes for redundancy.
{{/if}}

---

<LinuxConfiguration />

---

<LinuxInstallation />

<SupportLink />

---

<LinuxVerification />

---

{{#if entitlements.isHAEnabled}}
## Adding Worker Nodes

```bash
{{ app.slug }} join-token
# Run the output on each additional node
```
{{/if}}

---

<InstanceName />

---

<PostInstall>

After installation completes:

1. **TLS Certificates** — Set up HTTPS for the admin console
2. **Backup Schedule** — Configure automated backups
3. **Identity Provider** — Connect your SSO provider

</PostInstall>

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
