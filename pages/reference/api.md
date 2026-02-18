---
title: API Reference
description: ChartSmith REST API reference
weight: 300
---

# API Reference

{{ app.name }} exposes a REST API for programmatic access to chart management.

## Authentication

All API requests require a Bearer token:

```bash
curl -H "Authorization: Bearer <API_TOKEN>" \
  https://chartsmith.yourdomain.com/api/v1/charts
```

Generate an API token from the {{ app.name }} UI under **Settings → API Tokens**.

## Endpoints

### Charts

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/charts` | List all charts |
| `GET` | `/api/v1/charts/:name` | Get chart details |
| `POST` | `/api/v1/charts` | Upload a chart |
| `DELETE` | `/api/v1/charts/:name/:version` | Delete a chart version |

### Repositories

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/repos` | List repositories |
| `POST` | `/api/v1/repos` | Create a repository |
| `DELETE` | `/api/v1/repos/:name` | Delete a repository |

### Users

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/users` | List users |
| `POST` | `/api/v1/users` | Create a user |
| `PUT` | `/api/v1/users/:id` | Update a user |
| `DELETE` | `/api/v1/users/:id` | Delete a user |
