---
title: Linux Installation
description: Install {{ app.name }} on a Linux server with embedded Kubernetes
visible_when:
  entitlements:
    - isEmbeddedClusterDownloadEnabled
weight: 150
install_type: linux
---

# Linux Installation (v3.0.0)

Install {{ app.name }} v3.0.0 on a Linux server. This is the latest release with the fastest installer and new automatic cluster health checks.

## Requirements

- Ubuntu 22.04+, RHEL 9+, or Debian 12+ (64-bit)
- 4 CPUs, 8 GB RAM, 40 GB disk minimum
- Root or sudo access
- Port 443 outbound (or air gap bundle)

See the full [system requirements](/content/installation/requirements).

---

## Before You Begin

- Have root or sudo access ready
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

{{#if entitlements.isHAEnabled}}
> **High Availability:** v3.0.0 features zero-downtime node joins. Add worker nodes at any time without disrupting running workloads.
{{/if}}

---

## Install

Download and run the installer on your target machine:

```bash
curl -f https://replicated.app/embedded/{{ app.slug }}/{{ channel.slug }} -H "Authorization: {{ license.id }}" -o {{ app.slug }}-install.sh
sudo bash {{ app.slug }}-install.sh
```

The installer will:
1. Run automatic pre-flight health checks (new in v3.0.0)
2. Provision an embedded Kubernetes cluster
3. Deploy {{ app.name }} v3.0.0 and all dependencies
4. Start the Admin Console on port 8800

---

## Verify Installation

```bash
kubectl get pods -A
echo "Admin Console: https://$(hostname):8800"
```

{{#if entitlements.isHAEnabled}}
---

## Adding Worker Nodes

```bash
{{ app.slug }} join-token
# Run the output on each additional node — zero-downtime join in v3.0.0
```
{{/if}}

---

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
