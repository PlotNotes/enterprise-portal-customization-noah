---
title: Frequently Asked Questions
---

# Frequently Asked Questions

## General

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
### What are the system requirements?

See [Requirements](../installation/requirements) for details.
{{/if}}

### How do I check for updates?

See [Checking for Updates](../updates/checking).

{{#if entitlements.isHelmInstallEnabled}}
## Installation

### Which installation method should I use?

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
Choose [Embedded Cluster (Linux)](../installation/linux) for installing on a Linux server, or [Helm](../installation/helm) for deploying to an existing Kubernetes cluster.
{{/if}}
{{/if}}

## Troubleshooting

### How do I collect diagnostic information?

Generate a support bundle for troubleshooting:

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
- [Linux installations](../operations/bundles/linux)
{{/if}}
{{#if entitlements.isHelmInstallEnabled}}
- [Helm installations](../operations/bundles/helm)
{{/if}}
- If you already have a support bundle, [upload it here](../operations/bundles/uploaded)
