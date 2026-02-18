---
title: Upgrading
description: Upgrade {{ app.name }} to a new version
weight: 300
---

# Upgrading {{ app.name }}

## Check Available Versions

Visit the [Release History](/installation/release-history) page to see available versions for your channel.

## Before Upgrading

1. Review the release notes for breaking changes
2. [Back up your database](/operations/backup)
3. Test the upgrade in a non-production environment if possible

{{#if entitlements.isHelmInstallEnabled}}
## Helm Upgrade

```bash
helm upgrade {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --version <NEW_VERSION> \
  --namespace chartsmith \
  --reuse-values
```
{{/if}}

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
## Linux Upgrade

Use the admin console to check for and apply updates, or:

```bash
chartsmith update check
chartsmith update apply
```
{{/if}}

## Rollback

If something goes wrong:

{{#if entitlements.isHelmInstallEnabled}}
```bash
helm rollback {{ app.slug }} --namespace chartsmith
```
{{/if}}

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
```bash
chartsmith update rollback
```
{{/if}}
