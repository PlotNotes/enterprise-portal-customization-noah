---
title: Linux Installation
description: Install {{ app.name }} on a Linux server with embedded Kubernetes
visible_when:
  entitlements:
    - isEmbeddedClusterDownloadEnabled
weight: 150
install_type: linux
---

# Linux Installation (v1.0.0)

Install {{ app.name }} v1.0.0 on a Linux server. This method provisions an embedded Kubernetes cluster with everything pre-configured.

<LinuxRequirements />

---

## Before You Begin

- Have root or sudo access ready
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

{{#if entitlements.isHAEnabled}}
> **High Availability:** This application supports multi-node deployments. After completing the single-node installation below, you can add worker nodes for redundancy.
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
# On the first node, generate a join token:
{{ app.slug }} join-token

# On each additional node, run the join command output above
```
{{/if}}

---

<InstanceName />

---

<PostInstall>

After installation completes:

1. Set up TLS certificates for the admin console
2. Configure automated backups

</PostInstall>

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
