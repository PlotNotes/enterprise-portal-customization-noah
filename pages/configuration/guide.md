---
title: Configuration Guide
description: Configure {{ app.name }} for your environment
weight: 100
---

# Configuration Guide

{{ app.name }} is configured through Helm values (for Helm installs) or the admin console (for Linux installs).

## Core Configuration

### Domain

```yaml
global:
  domain: chartsmith.yourdomain.com
```

### License

Your license ID is automatically configured during installation. To update:

```yaml
license:
  id: {{ license.id }}
```

### Database

By default, {{ app.name }} uses an embedded PostgreSQL database. For production, configure an external database:

```yaml
database:
  external: true
  uri: "postgresql://user:password@host:5432/chartsmith"
```

See [Database Configuration](/configuration/database) for details.

## Environment-Specific Settings

See [Environment Variables](/configuration/environment) for the full list of configurable options.
