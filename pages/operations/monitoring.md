---
title: Monitoring & Metrics
description: Monitor {{ app.name }} with Prometheus and Grafana
weight: 100
---

# Monitoring & Metrics

<Note>
<ValueDisplay path="app.name" fallback="The application" /> exposes Prometheus metrics on port **9090** by default.
</Note>

## Prometheus

Add the following scrape config to your Prometheus configuration:

<CommandBlock label="yaml">
- job_name: chartsmith
  kubernetes_sd_configs:
    - role: pod
      namespaces:
        names: [chartsmith]
  relabel_configs:
    - source_labels: [__meta_kubernetes_pod_label_app]
      regex: chartsmith
      action: keep
</CommandBlock>

## Key Metrics

| Metric | Description |
|--------|-------------|
| `chartsmith_charts_total` | Total charts managed |
| `chartsmith_pulls_total` | Total chart pulls |
| `chartsmith_api_request_duration_seconds` | API latency |
| `chartsmith_storage_bytes` | Storage usage |

## Alerting

<Warning>
Set up alerts for these critical conditions to avoid downtime.
</Warning>

<Accordion title="Recommended Alert Rules">

- `chartsmith_api_request_duration_seconds > 5` — API latency high
- `up{job="chartsmith"} == 0` — Instance down
- `chartsmith_storage_bytes > 0.9 * limit` — Storage near capacity

</Accordion>
