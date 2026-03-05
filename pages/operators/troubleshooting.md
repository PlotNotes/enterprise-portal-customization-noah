---
title: Troubleshooting
description: Common issues and solutions for {{ app.name }} Kubernetes deployments
weight: 100
---

# Troubleshooting

Solutions for common issues in {{ app.name }} Kubernetes deployments. For additional assistance, generate a [support bundle](#support-bundle) and share it with the support team.

## Diagnostic Commands

Start by gathering system information:

<CommandBlock>
# Check {{ app.name }} resources
kubectl get all -n {{ app.slug }} -l app.kubernetes.io/name={{ app.slug }}

# Review recent cluster events
kubectl get events -n {{ app.slug }} --sort-by='.lastTimestamp'

# Check pod status and node distribution
kubectl get pods -n {{ app.slug }} -o wide

# View web service logs
kubectl logs -n {{ app.slug }} -l app.kubernetes.io/component=web --tail=100

# View worker service logs
kubectl logs -n {{ app.slug }} -l app.kubernetes.io/component=worker --tail=100

# Monitor resource consumption
kubectl top nodes
kubectl top pods -n {{ app.slug }}
</CommandBlock>

---

## Pod CrashLoopBackOff

Pods restart continuously. Common causes include missing secrets, database connection failures, restrictive resource limits, and invalid configuration.

<CommandBlock>
# Check pod logs for errors
kubectl logs -n {{ app.slug }} <pod-name> --previous

# Examine pod details and events
kubectl describe pod -n {{ app.slug }} <pod-name>
</CommandBlock>

---

## Pod Startup Failures

If pods fail to start:

- Check logs for error messages
- Validate resource limits aren't overly restrictive
- Confirm all required secrets exist
- Verify image pull credentials are configured

<CommandBlock>
kubectl get pods -n {{ app.slug }}
kubectl describe pod -n {{ app.slug }} <pod-name>
</CommandBlock>

---

## Database Connection Issues

When database connections fail:

1. Verify `DB_HOST` is correct for your external database
2. Check credentials in your Kubernetes secrets
3. Ensure firewall/security groups allow access from the cluster
4. Validate database name and port settings

For OAuth integration with external databases, confirm the OAuth database exists (default name: `oauth_db`).

Test connectivity from within the cluster:

<CommandBlock>
kubectl run -it --rm pg-test --image=postgres:16 -n {{ app.slug }} -- \
  psql "postgresql://DB_USER:DB_PASSWORD@DB_HOST:5432/DB_NAME"
</CommandBlock>

---

## Storage / S3 Connection Issues

- Validate AWS credentials or service account permissions
- Confirm bucket name and region are correct
- Ensure IAM permissions allow bucket access (`GetObject`, `PutObject`, `DeleteObject`, `ListBucket`)
- For internal MinIO, verify the endpoint is accessible from pods

<CommandBlock>
# Test S3 access from a pod
kubectl run -it --rm aws-test --image=amazon/aws-cli -n {{ app.slug }} -- \
  s3 ls s3://your-bucket-name
</CommandBlock>

---

## Image Pull Errors

If pods show `ImagePullBackOff` or `ErrImagePull`:

- Confirm image names and tags exist in the registry
- Check pull secret configuration
- Validate registry credentials
- Test network connectivity to the registry

<CommandBlock>
kubectl get events -n {{ app.slug }} --field-selector reason=Failed

# Re-authenticate with the registry
helm registry login registry.replicated.com \
  --username {{ customer.email }} \
  --password {{ license.id }}
</CommandBlock>

---

## Ingress Not Accessible

<CommandBlock>
kubectl get ingress -n {{ app.slug }}
kubectl describe ingress -n {{ app.slug }}
</CommandBlock>

Check:

- Ingress controller is installed and running
- `className` matches your ingress controller type
- DNS resolves to the load balancer IP/hostname
- TLS certificate is valid and correctly referenced

---

## Out of Memory (OOMKilled)

If pods are killed due to memory pressure:

<CommandBlock>
# Check which pods are using the most memory
kubectl top pods -n {{ app.slug }} --sort-by=memory
</CommandBlock>

Solutions:

- Increase memory limits in your values file
- Tune concurrency parameters (`WEB_CONCURRENCY`, `RAILS_MAX_THREADS`)
- Monitor actual usage patterns to right-size resources

---

## BuildKit Build Failures

Crew builds may fail due to registry authentication, insufficient resources, or network issues.

<CommandBlock>
# Check BuildKit pod status
kubectl get pods -n {{ app.slug }} -l app.kubernetes.io/component=buildkit

# Review BuildKit logs
kubectl logs -n {{ app.slug }} -l app.kubernetes.io/component=buildkit --tail=100
</CommandBlock>

Solutions:

- Verify registry authentication secrets are correct
- Increase BuildKit resource allocations
- For internal registries, configure insecure registry settings if needed

---

## Persistent Volume Issues

Pods stuck in `Pending` state may indicate PVC binding problems.

<CommandBlock>
# Check PVC status
kubectl get pvc -n {{ app.slug }}

# Describe PVC for events
kubectl describe pvc -n {{ app.slug }} <pvc-name>

# Verify StorageClass availability
kubectl get storageclass
</CommandBlock>

If no default StorageClass is set:

<CommandBlock>
kubectl patch storageclass <your-storage-class> \
  -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
</CommandBlock>

---

## Authentication Provider Issues

### Microsoft Entra ID

<CommandBlock>
# Verify secrets exist
kubectl get secret -n {{ app.slug }} -o jsonpath='{.data}' | grep -c ENTRA_ID
</CommandBlock>

- Confirm `ENTRA_ID_CLIENT_ID` and `ENTRA_ID_TENANT_ID` are set
- Redirect URI must be: `https://YOUR_HOST/auth/entra_id/callback`
- `APPLICATION_HOST` environment variable must match your deployment domain

### Okta

- Validate `OKTA_SITE` and `OKTA_CLIENT_ID` are correct
- Redirect URI must be: `https://YOUR_HOST/auth/okta/callback`

---

## Secret Management Issues

<CommandBlock>
# Check secrets exist
kubectl get secrets -n {{ app.slug }}

# For external secret stores
kubectl get secretstore -n {{ app.slug }}
kubectl get externalsecret -n {{ app.slug }}

# Check External Secrets Operator logs
kubectl logs -n external-secrets-operator -l app.kubernetes.io/name=external-secrets --tail=50
</CommandBlock>

---

## RAILS_MASTER_KEY Warning

The chart automatically manages `RAILS_MASTER_KEY` — manual configuration is not required.

If you see warnings about this key, remove `RAILS_MASTER_KEY` from the `envVars` and `secrets` sections of your values file, then upgrade:

<CommandBlock>
helm upgrade {{ app.slug }} \
  oci://registry.replicated.com/{{ app.slug }}/{{ channel.slug }}/{{ app.slug }} \
  --version {{ release.version }} \
  --values my-values.yaml \
  --namespace {{ app.slug }}
</CommandBlock>

---

## Performance Issues

If experiencing slow response times:

<CommandBlock>
# Check resource utilization
kubectl top nodes
kubectl top pods -n {{ app.slug }} --sort-by=cpu

# Review slow query logs
kubectl logs -n {{ app.slug }} -l app.kubernetes.io/component=web --tail=200 | grep -i slow
</CommandBlock>

Solutions:

- Increase web replica count
- Increase resource allocations (CPU and memory)
- Tune `WEB_CONCURRENCY` and `RAILS_MAX_THREADS`
- Add database read replicas for your external PostgreSQL

---

## Support Bundle

Generate a support bundle for the {{ app.name }} support team:

<CommandBlock>
# Install the support-bundle plugin (if not already installed)
kubectl krew install support-bundle

# Generate the bundle
kubectl support-bundle --load-cluster-specs
</CommandBlock>

The bundle includes pod logs, resource configurations, cluster state, event history, and secret names (values are excluded). Share the generated `.tar.gz` file with support.

<SupportBundleUploadHistory limit={3}/>

### Support Resources

- **Customer Portal:** [enterprise.crewai.com](https://enterprise.crewai.com/crewai)
- **Release History:** [Release Notes](https://enterprise.crewai.com/crewai/release-history)
- **License:** `{{ license.id }}` (version {{ release.version }} on {{ channel.name }})
