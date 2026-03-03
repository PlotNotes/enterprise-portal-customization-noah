---
title: Requirements
description: System requirements for {{ app.name }}
weight: 100
---

# System Requirements

Before installing {{ app.name }}, ensure your environment meets the following requirements.

## Kubernetes Infrastructure

<Note>
{{ app.name }} requires **Kubernetes 1.32.0 or later** with the `apps/v1`, `v1`, `batch/v1`, and `networking.k8s.io/v1` API groups enabled.
</Note>

### Cluster Resources

| Component | Minimum (per node) | Recommended |
|-----------|-------------------|-------------|
| Memory | 8 Gi | 16 Gi |
| CPU | 4 cores | 8 cores |
| Ephemeral Storage | 10 Gi | 20 Gi |

{{#if entitlements.isHAEnabled}}

<Accordion title="High Availability Requirements" defaultOpen={false}>

Production deployments should use 3 or more nodes. Multiply the per-node requirements by your node count.

| Component | Per Node | 3-Node Cluster |
|-----------|----------|-----------------|
| Memory | 8 Gi | 24 Gi |
| CPU | 4 cores | 12 cores |
| Ephemeral Storage | 10 Gi | 30 Gi |

</Accordion>

{{/if}}

## Data Storage

### PostgreSQL Database

A **PostgreSQL 16.8+** database is required with `CREATE`, `DROP`, and `ALTER` privileges.

Compatible providers include:

{{#if entitlements.isAWSEnabled}}
- AWS Aurora PostgreSQL
{{/if}}
{{#if entitlements.isAzureEnabled}}
- Azure Database for PostgreSQL
{{/if}}
{{#if entitlements.isGCPEnabled}}
- Google Cloud SQL for PostgreSQL
{{/if}}
- Self-managed PostgreSQL instances

The database must be network-accessible from cluster pods. SSL/TLS connections are recommended.

### S3-Compatible Object Storage

Full S3 API compatibility is required. You must pre-create your storage buckets and provide read/write access credentials.

## Network Requirements

Functional cluster DNS (CoreDNS or kube-dns) is required for pod service discovery.

| Port | Protocol | Direction | Purpose |
|------|----------|-----------|---------|
| 443 | TCP | Outbound | Object storage, registry access |
| 443 | TCP | Inbound | Ingress traffic (HTTPS) |
| 80 | TCP | Inbound | Ingress traffic (HTTP) |
| 5432 | TCP | Internal | PostgreSQL database connectivity |

{{#if entitlements.isHAEnabled}}

<Accordion title="HA Network Requirements">

| Port | Protocol | Direction | Purpose |
|------|----------|-----------|---------|
| 2379-2380 | TCP | Internal | etcd peer communication |
| 9443 | TCP | Internal | Join server |
| 10250 | TCP | Internal | Kubelet API |

</Accordion>

{{/if}}

## Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Helm | 3.10+ | Deploying {{ app.name }} to Kubernetes |
| kubectl | Compatible with your cluster version | Cluster management |

### Registry Access

{{ app.name }} images are distributed through the Replicated registry. Authenticate with your service account token:

<CommandBlock command="helm registry login registry.replicated.com --username {{ customer.email }} --password {{ license.id }}" />

## TLS Certificates

<Warning>
Production deployments **require** valid TLS certificates in PEM-encoded format from a trusted or internal certificate authority.
</Warning>

Supported provisioning methods include:

{{#if entitlements.isAWSEnabled}}
- AWS Certificate Manager
{{/if}}
- cert-manager (automated provisioning within Kubernetes)
- Manual upload as Kubernetes secrets
