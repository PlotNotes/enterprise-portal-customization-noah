---
title: Welcome to {{ app.name }}
description: Get started with {{ app.name }} — your enterprise chart management platform
layout: doc
---

# Welcome to {{ app.name }}

Hello, **{{ customer.name }}**! This portal contains everything you need to install, configure, and operate {{ app.name }} in your environment.

You're on the **{{ channel.name }}** channel, running version **{{ release.version }}**.

## Quick Start

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
### Linux (Recommended)
If you don't have access to a K8s cluster.... our Linux installer provisions a complete Kubernetes cluster with {{ app.name }} pre-configured.

→ [Linux Installation Guide](/installation/linux)
{{/if}}

{{#if entitlements.isHelmInstallEnabled}}
### Helm
Deploy to your existing Kubernetes cluster using Helm.

→ [Helm Installation Guide](/installation/helm)
{{/if}}

## Before You Begin

1. Review the [Requirements](/installation/requirements) for your deployment method
{{#if terraform_modules.aws-infrastructure}}
2. Provision your cloud infrastructure using our [Terraform modules](/infrastructure/overview)
{{/if}}
3. Follow the installation guide for your chosen method
4. Complete [Post-Installation](/installation/post-installation) steps

## What's Included

Your {{ channel.name }} license includes:

{{#if entitlements.isHelmInstallEnabled}}
- ✅ Helm-based installation
{{/if}}
{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
- ✅ Linux embedded cluster installation
{{/if}}
{{#if entitlements.isAirgapSupported}}
- ✅ Air gap deployment support
{{/if}}
{{#if entitlements.isHAEnabled}}
- ✅ High availability configuration
{{/if}}
{{#if entitlements.isAWSEnabled}}
- ✅ AWS Terraform modules
{{/if}}
{{#if entitlements.isGCPEnabled}}
- ✅ GCP Terraform modules
{{/if}}
{{#if entitlements.isAzureEnabled}}
- ✅ Azure Terraform modules
{{/if}}

## Need Help?

Check our [Troubleshooting Guide](/operations/troubleshooting) or [Contact Support](/support/contact).
