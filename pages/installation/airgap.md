---
title: Air Gap Installation
description: Install {{ app.name }} in disconnected environments
visible_when:
  entitlements:
    - isAirgapSupported
weight: 300
---

# Air Gap Installation

Install {{ app.name }} in environments without direct internet access.

<Warning>
Air gap installations require pre-downloading all bundles from a machine with internet access. Plan your transfer method before beginning.
</Warning>

<Prerequisites title="Before You Begin">

- Review the [System Requirements](/installation/requirements)
- A machine with internet access for downloading bundles
- An approved transfer method to your air gap environment (USB drive, bastion host, etc.)

</Prerequisites>

---

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
## Linux Air Gap Installation

Install {{ app.name }} on a Linux server in an air-gapped environment using Embedded Cluster.

<LinuxAirgapInstallAssets stepNumber={1} />
{{/if}}

{{#if entitlements.isHelmAirgapEnabled}}
## Helm Air Gap Installation

Install {{ app.name }} on your existing Kubernetes cluster using Helm in an air-gapped environment.

<HelmAirgapInstallAssets stepNumber={1} />
{{/if}}

---

## Updating in Air Gap

Download the new version's air gap bundle from the [Release History](/installation/release-history) page and repeat the installation steps above with the new bundle.

<InstanceName />

## Next Steps

- [Post-Installation steps](/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
