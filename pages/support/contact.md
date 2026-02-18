---
title: Contact Support
description: Get help with {{ app.name }}
weight: 200
---

# Contact Support

## Support Channels

- **Email**: support@chartsmith.io
- **Slack**: [ChartSmith Community](https://chartsmith.slack.com)
- **GitHub**: [Issue Tracker](https://github.com/chartsmith/chartsmith/issues)

## Before Contacting Support

Please have the following ready:

1. Your {{ app.name }} version: `{{ release.version }}`
2. Your license ID: `{{ license.id }}`
3. Installation method (Helm or Linux)
4. A [support bundle](/operations/troubleshooting) if applicable

## Support Bundle

Generate and upload a support bundle for faster resolution:

```bash
kubectl support-bundle --namespace chartsmith
```

## SLA

| Channel | Response Time |
|---------|--------------|
| {{ channel.name }} | Based on your support agreement |

Contact your account manager for SLA details.
