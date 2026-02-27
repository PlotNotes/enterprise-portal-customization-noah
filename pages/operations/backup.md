---
title: Backup & Restore
description: Backup and restore procedures for {{ app.name }}
weight: 200
---

# Backup & Restore

<Warning>
Regular backups are critical for disaster recovery. Configure automated backups before going to production.
</Warning>

## What to Back Up

<Note>
{{ app.name }} stores data in two locations that both need to be backed up:

1. **Database** — PostgreSQL database containing chart metadata and user data
2. **Object Storage** — Chart packages stored in S3/GCS/Azure Blob
</Note>

## Automated Backups

Enable automated database backups by adding this to your values file:

<CommandBlock label="yaml">
backup:
  enabled: true
  schedule: "0 2 * * *"  # Daily at 2 AM
  retention: 30           # Keep 30 days
  destination:
    type: s3
    bucket: chartsmith-backups
    region: us-west-2
</CommandBlock>

## Manual Backup

<Tabs>
<Tab title="Internal PostgreSQL">

<CommandBlock command="kubectl exec -n chartsmith deploy/chartsmith-postgresql -- pg_dump -U chartsmith -Fc > chartsmith-backup.dump" />

</Tab>
<Tab title="External Database">

<CommandBlock command="pg_dump -h HOST -U chartsmith -Fc > chartsmith-backup.dump" />

</Tab>
</Tabs>

## Restore

<Warning>
Restoring a backup will **overwrite** all current data. Make sure you have a recent backup of the current state before restoring an older one.
</Warning>

<InstallStep stepNumber={1} title="Stop the Application">

<CommandBlock command="kubectl -n chartsmith scale deploy/chartsmith --replicas=0" />

</InstallStep>

<InstallStep stepNumber={2} title="Restore the Database">

<CommandBlock command="pg_restore -h HOST -U chartsmith -d chartsmith chartsmith-backup.dump" />

</InstallStep>

<InstallStep stepNumber={3} title="Restart the Application">

<CommandBlock command="kubectl -n chartsmith scale deploy/chartsmith --replicas=3" />

</InstallStep>
