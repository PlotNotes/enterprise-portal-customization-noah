---
title: Environment Variables
description: Environment variable reference for {{ app.name }}
weight: 200
---

# Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CHARTSMITH_LOG_LEVEL` | Log verbosity (debug, info, warn, error) | `info` |
| `CHARTSMITH_DB_URI` | PostgreSQL connection string | embedded |
| `CHARTSMITH_DOMAIN` | Public domain name | — |
| `CHARTSMITH_TLS_CERT_PATH` | Path to TLS certificate | — |
| `CHARTSMITH_TLS_KEY_PATH` | Path to TLS private key | — |
| `CHARTSMITH_METRICS_ENABLED` | Enable Prometheus metrics | `true` |
| `CHARTSMITH_METRICS_PORT` | Prometheus metrics port | `9090` |
| `CHARTSMITH_S3_BUCKET` | S3 bucket for chart storage | — |
| `CHARTSMITH_S3_REGION` | S3 bucket region | — |
