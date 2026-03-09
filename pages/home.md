---
title: Documentation
---

# Documentation

Welcome to your personalized documentation portal. The navigation and content are customized based on your license entitlements.

## Available Features

Your installation includes access to the following features:

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
- **Linux (Embedded Cluster):** Install on a Linux server using Embedded Cluster
{{/if}}
{{#if entitlements.isHelmInstallEnabled}}
- **Helm Installation:** Deploy to existing Kubernetes clusters using Helm charts
{{/if}}
{{#if entitlements.isAirgapSupported}}
- **Air Gap Support:** Install in disconnected environments
{{/if}}

## Getting Started

Use the sidebar navigation on the left to explore available documentation sections. We recommend starting with:

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
1. **Installation Requirements** — Review system requirements and prerequisites for Embedded Cluster installations
{{/if}}
2. **Installation Guide** — Follow step-by-step installation instructions for your deployment method
3. **Updates** — Check for and manage application updates
4. **Support Bundles** — Generate diagnostic bundles for troubleshooting

## Quick Links

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
- [Installation Requirements](installation/requirements)
- [Linux Installation](installation/linux)
{{/if}}
{{#if entitlements.isHelmInstallEnabled}}
- [Helm Installation](installation/helm)
{{/if}}
- [Release History](installation/release-history)
- [Check for Updates](updates/checking)
- [Support Bundles](operations/bundles/uploaded)
- [FAQ](support/faq)
