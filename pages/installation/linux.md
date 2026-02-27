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

<LinuxRequirements />

---

## Before You Begin

- Have root or sudo access ready
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

{{#if entitlements.isHAEnabled}}
> **High Availability:** v3.0.0 features zero-downtime node joins. Add worker nodes at any time without disrupting running workloads.
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
# Run the output on each additional node — zero-downtime join in v3.0.0
```
{{/if}}

---

<InstanceName />

---

<PostInstall>

After installation completes, configure the following for your v3.0.0 deployment:

1. **TLS Certificates** — Set up HTTPS for the admin console and application endpoints
2. **Backup Schedule** — Configure automated backups using the built-in snapshot system
3. **Identity Provider** — Connect your SSO provider for user authentication
4. **Monitoring** — v3.0.0 includes built-in Prometheus metrics on port 9090

</PostInstall>

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
