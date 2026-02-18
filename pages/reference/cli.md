---
title: CLI Reference
description: ChartSmith CLI command reference
weight: 200
---

# CLI Reference

The `chartsmith` CLI is available on Linux installations and can also be installed standalone.

## Commands

### `chartsmith status`
Show the status of all ChartSmith components.

### `chartsmith update check`
Check for available updates.

### `chartsmith update apply`
Apply a pending update.

### `chartsmith update rollback`
Roll back to the previous version.

### `chartsmith backup create`
Create a manual backup.

### `chartsmith backup list`
List available backups.

### `chartsmith backup restore <BACKUP_ID>`
Restore from a backup.

### `chartsmith join-token`
Generate a join token for adding nodes (HA only).

### `chartsmith preflight`
Run preflight checks against the current environment.

### `chartsmith reset`
Reset the installation (destructive — removes all data).
