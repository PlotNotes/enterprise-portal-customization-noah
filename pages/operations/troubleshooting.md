---
title: Troubleshooting
description: Common issues and solutions for {{ app.name }}
weight: 400
---

# Troubleshooting

## Common Issues

<Accordion title="Pods not starting">

<CommandBlock>
kubectl -n chartsmith get pods
kubectl -n chartsmith describe pod <POD_NAME>
kubectl -n chartsmith logs <POD_NAME>
</CommandBlock>

</Accordion>

<Accordion title="Database connection failed">

1. Verify the connection string is correct
2. Check network connectivity to the database host
3. Verify the database user has appropriate permissions

<Tip>
Test connectivity directly from a pod:
</Tip>

<CommandBlock command="kubectl -n chartsmith exec -it deploy/chartsmith-web -- pg_isready -h $DB_HOST" />

</Accordion>

<Accordion title="Registry authentication failed">

Re-authenticate with the registry:

<CommandBlock command="helm registry login registry.replicated.com --username {{ customer.email }} --password {{ license.id }}" />

</Accordion>

<Accordion title="License expired">

Your license expires on {{ license.expiresAt }}. Contact your account manager or [support](/support/contact) to renew.

</Accordion>

## Support Bundles

Generate a support bundle for our team:

<CommandBlock command="kubectl support-bundle --namespace chartsmith" />

<SupportBundleUpload />

## Preflight Checks

Run preflight checks to validate your environment:

<CommandBlock command="kubectl preflight --namespace chartsmith" />
