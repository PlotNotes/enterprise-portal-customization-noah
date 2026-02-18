---
title: FAQ
description: Frequently asked questions about {{ app.name }}
weight: 100
---

# Frequently Asked Questions

## General

### What Kubernetes versions are supported?

{{ app.name }} supports Kubernetes 1.27 and later.

### Can I run {{ app.name }} on-premises?

Yes. {{ app.name }} is designed for on-premises, air-gapped, and cloud deployments.

### How do I check my license?

Visit the [License](/license) page in this portal to view your license details, entitlements, and expiration date.

## Installation

### Which installation method should I use?

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
- **Linux**: Best for single-server deployments or when you don't have an existing Kubernetes cluster.
{{/if}}
{{#if entitlements.isHelmInstallEnabled}}
- **Helm**: Best when you have an existing Kubernetes cluster and want full control.
{{/if}}

### Can I migrate between installation methods?

Not directly. We recommend a fresh install with data migration via database backup/restore.

## Licensing

### What happens when my license expires?

{{ app.name }} continues to run but you won't be able to pull updates or access new releases.

### How do I renew my license?

Contact your account manager or reach out via [Contact Support](/support/contact).
