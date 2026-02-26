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

## Requirements

- Ubuntu 20.04+, RHEL 8+, or CentOS 8+ (64-bit)
- 4 CPUs, 8 GB RAM, 40 GB disk minimum
- Root or sudo access
- Port 443 outbound (or air gap bundle)

See the full [system requirements](/content/installation/requirements).

---

## Before You Begin

- Have root or sudo access ready
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

{{#if entitlements.isHAEnabled}}
> **High Availability:** This application supports multi-node deployments. After completing the single-node installation below, you can add worker nodes for redundancy.
{{/if}}

---

## Install

Download and run the installer on your target machine:

```bash
curl -f https://replicated.app/embedded/{{ app.slug }}/{{ channel.slug }} -H "Authorization: {{ license.id }}" -o {{ app.slug }}-install.sh
sudo bash {{ app.slug }}-install.sh
```

The installer will:
1. Provision an embedded Kubernetes cluster
2. Deploy {{ app.name }} and all dependencies
3. Start the Admin Console on port 8800

---

## Verify Installation

Once the installer completes, verify everything is running:

```bash
kubectl get pods -A
echo "Admin Console: https://$(hostname):8800"
```

{{#if entitlements.isHAEnabled}}
---

## Adding Worker Nodes

To add additional nodes for high availability:

```bash
# On the first node, generate a join token:
{{ app.slug }} join-token

# On each additional node, run the join command output above
```
{{/if}}

---

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
