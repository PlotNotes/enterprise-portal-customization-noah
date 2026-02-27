---
title: Upgrading
description: Upgrade {{ app.name }} to a new version
weight: 300
---

# Upgrading {{ app.name }}

## Available Versions

<ReleaseHistory limit={5} />

## Before Upgrading

<Warning>
Always review the release notes for breaking changes and back up your database before upgrading. Test in a non-production environment when possible.
</Warning>

<Prerequisites title="Upgrade Checklist">

- Review the release notes for breaking changes
- [Back up your database](/operations/backup)
- Test the upgrade in a non-production environment if possible

</Prerequisites>

<ConditionalRender when="entitlements.isHelmInstallEnabled">

## Helm Upgrade

<InstallStep stepNumber={1} title="Upgrade via Helm">

<CommandBlock command={`helm upgrade {{ app.slug }} oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} --version <NEW_VERSION> --namespace chartsmith --reuse-values`} />

</InstallStep>

</ConditionalRender>

<ConditionalRender when="entitlements.isEmbeddedClusterDownloadEnabled">

## Linux Upgrade

<InstallStep stepNumber={1} title="Upgrade via CLI">

Use the admin console to check for and apply updates, or use the CLI:

<CodeBlock language="bash">
{`chartsmith update check
chartsmith update apply`}
</CodeBlock>

</InstallStep>

</ConditionalRender>

## Rollback

<Warning>
Only roll back if the upgrade caused issues. Rollbacks may not reverse database migrations.
</Warning>

<ConditionalRender when="entitlements.isHelmInstallEnabled">

<CommandBlock command="helm rollback {{ app.slug }} --namespace chartsmith" />

</ConditionalRender>

<ConditionalRender when="entitlements.isEmbeddedClusterDownloadEnabled">

<CommandBlock command="chartsmith update rollback" />

</ConditionalRender>
