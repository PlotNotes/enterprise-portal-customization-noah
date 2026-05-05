---
title: Welcome to {{ app.name }}
description: Get started with {{ app.name }} — your enterprise chart management platform
layout: doc
---

# Welcome to {{ app.name }} — {{_version}}

<svg xmlns="http://www.w3.org/2000/svg" width="300" height="60" viewBox="0 0 300 60">
  <defs>
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@700');
    </style>
  </defs>
  <text x="10" y="45" font-family="Inter, sans-serif" font-size="32" fill="#1a1a1a">
    ACME Corporation
  </text>
</svg>

<Note title="Latest Release">
You are viewing the **{{_version}}** documentation. This is the latest release with cutting-edge features.
</Note>

Hello, **{{ customer.name }}**! This portal contains everything you need to install, configure, and operate {{ app.name }} in your environment.

You're on the **{{ channel.name }}** channel, running version **{{ release.version }}**.

## Quick Start

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}

### Linux (Recommended)

If you don't have access to a K8s cluster, our Linux installer provisions a complete Kubernetes cluster with {{ app.name }} pre-configured.

[Linux Install](/installation/linux)

{{/if}}

{{#if entitlements.isHelmInstallEnabled}}

### Helm

Deploy to your existing Kubernetes cluster using Helm.

[Helm Install](/installation/helm)

{{/if}}

## Before You Begin

<Prerequisites title="Checklist">

- Review the [Requirements](/installation/requirements) for your deployment method
- Provision your cloud infrastructure if applicable
- Follow the installation guide for your chosen method
- Complete [Post-Installation](/installation/post-installation) steps

</Prerequisites>

## What's Included

Your {{ channel.name }} license includes:

{{#if entitlements.isHelmInstallEnabled}}

- Helm-based installation

{{/if}}

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}

- Linux embedded cluster installation

{{/if}}

{{#if entitlements.isAirgapSupported}}

- Air gap deployment support

{{/if}}

{{#if entitlements.isHAEnabled}}

- High availability configuration

{{/if}}

## Need Help?

<Tip>
Check our [Troubleshooting Guide](/operations/troubleshooting) for common issues, or head to [Contact Support](/support/contact) to upload a support bundle and reach our team.
</Tip>
