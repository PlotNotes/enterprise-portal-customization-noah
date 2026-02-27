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

<Note>
Please have the following information ready when contacting support:
</Note>

1. Your {{ app.name }} version: `{{ release.version }}`
2. Your customer name: **<ValueDisplay path="customer.name" fallback="(check your license)" />**
3. Installation method (Helm or Linux)
4. A support bundle (see below)

## Upload a Support Bundle

Generate a support bundle for faster resolution:

<CommandBlock command="kubectl support-bundle --namespace chartsmith" />

<SupportBundleUpload />

## SLA

| Channel | Response Time |
|---------|--------------|
| {{ channel.name }} | Based on your support agreement |

<Tip>
Contact your account manager for SLA details and to discuss priority support options.
</Tip>
