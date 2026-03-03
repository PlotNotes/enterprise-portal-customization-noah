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

- Ubuntu 20.04+, RHEL 8+, or CentOS 8+
- 4 CPUs, 8GB RAM, 40GB disk minimum
- Root or sudo access
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

{{#if entitlements.isHAEnabled}}
> **High Availability:** This application supports multi-node deployments. After completing the single-node installation below, you can add worker nodes for redundancy.
{{/if}}

---

## Step 1: Download and Install

Run the following command on your Linux server:

```bash
curl -f https://replicated.app/embedded/{{ app.slug }}/{{ channel.slug }} | sudo bash
```

This will download and install {{ app.name }} on a single Linux node. Ensure your server meets the minimum requirements before proceeding.

---

## Step 2: Verify the Installation

After installation completes, verify that all services are running:

```bash
{{ app.slug }} status
```

Check the admin console is accessible on port 8800:

```bash
curl -sk https://localhost:8800/api/v1/healthz
```

---

{{#if entitlements.isHAEnabled}}
## Step 3: Add Worker Nodes (Optional)

```bash
# On the first node, generate a join token:
{{ app.slug }} join-token

# On each additional node, run the join command output above
```
{{/if}}

## Post-Installation

After installation completes:

1. Set up TLS certificates for the admin console
2. Configure automated backups

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
