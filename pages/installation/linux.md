---
title: Linux Installation
description: Install {{ app.name }} on a Linux server with embedded Kubernetes
visible_when:
  entitlements:
    - isEmbeddedClusterDownloadEnabled
weight: 150
---

# Linux Installation

Install {{ app.name }} on a Linux server. This method provisions an embedded Kubernetes cluster with everything pre-configured.

## Prerequisites

- [System requirements](/installation/requirements) met
- Linux server with root access
- Internet access (or see [Air Gap Installation](/installation/airgap))

## Step 1: Download the Installer

```bash
curl -fSsL https://{{ app.slug }}.replicated.com/embedded/{{ channel.slug }}/install.sh | sudo bash
```

## Step 2: Configure

The installer will prompt you for:

- **Admin console password**: Used to access the admin UI
- **Domain name**: The hostname where {{ app.name }} will be accessible

{{#if entitlements.isHAEnabled}}
### Multi-Node Setup

To add worker nodes for high availability:

```bash
# On the first node, after installation:
chartsmith join-token

# On additional nodes:
curl -fSsL https://{{ app.slug }}.replicated.com/embedded/{{ channel.slug }}/join.sh | \
  sudo bash -s -- --token <JOIN_TOKEN>
```
{{/if}}

## Step 3: Verify

```bash
chartsmith status
```

All components should show `Ready`.

## Step 4: Access

Open `https://<your-domain>` in your browser.

## Next Steps

- [Post-Installation steps](/installation/post-installation)
- [Configuration Guide](/configuration/guide)
