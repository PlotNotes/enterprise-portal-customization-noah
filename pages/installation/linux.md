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

<Prerequisites title="Before You Begin">

- Have root or sudo access ready
- Review the [System Requirements](/installation/requirements)
- For air gap environments, see [Air Gap Installation](/content/installation/airgap)

</Prerequisites>

<ConditionalRender when="entitlements.isHAEnabled">

<Tip title="High Availability">
v3.0.0 features zero-downtime node joins. Add worker nodes at any time without disrupting running workloads.
</Tip>

</ConditionalRender>

--- 

<LinuxInstallAssets stepNumber={1} />

<InstallStep stepNumber={2} title="Verify the Installation">

After installation completes, verify that all services are running:

<CommandBlock command="{{ app.slug }} status" />

Check the admin console is accessible on port 8800:

<CommandBlock command="curl -sk https://localhost:8800/api/v1/healthz" />

</InstallStep>

<ConditionalRender when="entitlements.isHAEnabled">

<InstallStep stepNumber={3} title="Add Worker Nodes" optional={true}>

Generate a join token and run it on each additional node for zero-downtime join in v3.0.0:

<CommandBlock command="{{ app.slug }} join-token" />

</InstallStep>

</ConditionalRender>

<InstanceName />

---

## Post-Installation Configuration

<Accordion title="Recommended Next Steps" defaultOpen={true}>

After installation completes, configure the following for your v3.0.0 deployment:

1. **TLS Certificates** — Set up HTTPS for the admin console and application endpoints
2. **Backup Schedule** — Configure automated backups using the built-in snapshot system
3. **Identity Provider** — Connect your SSO provider for user authentication
4. **Monitoring** — v3.0.0 includes built-in Prometheus metrics on port 9090

</Accordion>

## Next Steps

- [Post-Installation steps](/content/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
