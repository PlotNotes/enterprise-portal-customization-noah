---
title: TLS Certificates
description: Configure TLS for {{ app.name }}
weight: 400
---

# TLS Configuration

{{ app.name }} should be configured with TLS for production use.

## Option 1: Let's Encrypt (Recommended)

```yaml
tls:
  enabled: true
  issuer: letsencrypt
  email: admin@yourdomain.com
```

## Option 2: Bring Your Own Certificate

```yaml
tls:
  enabled: true
  certificate: |
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----
  privateKey: |
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----
```

## Option 3: cert-manager

If you have cert-manager installed in your cluster:

```yaml
tls:
  enabled: true
  issuerRef:
    name: your-cluster-issuer
    kind: ClusterIssuer
```
