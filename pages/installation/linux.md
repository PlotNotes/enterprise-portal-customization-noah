---
title: Linux Installation
description: Install {{ app.name }} on a Linux server with embedded Kubernetes
visible_when:
  entitlements:
    - isEmbeddedClusterDownloadEnabled
weight: 150
install_type: linux
---

# Linux Installation

Install {{ app.name }} on a Linux server. This method provisions an embedded Kubernetes cluster with everything pre-configured.

<LinuxRequirements />

---

## Before You Begin

- Ensure your server meets the [system requirements](/content/installation/requirements)
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

To add additional nodes for high availability:

```bash
# On the first node, generate a join token:
chartsmith join-token

# On each additional node:
curl -fSsL https://{{ app.slug }}.replicated.com/embedded/{{ channel.slug }}/join.sh | \
  sudo bash -s -- --token <JOIN_TOKEN>
```
{{/if}}

---

<InstanceName />

---

<PostInstall />

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
