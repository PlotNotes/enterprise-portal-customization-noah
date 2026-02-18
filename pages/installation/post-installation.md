---
title: Post-Installation
description: Steps to complete after installing {{ app.name }}
weight: 900
---

# Post-Installation

After installing {{ app.name }}, complete the following configuration steps before the platform is ready for use.

## Initial Setup

### Initialize Internal Organization

```bash
kubectl exec -it deploy/{{ app.slug }}-web -- rake studio:install_internal_organization
```

### Set Up Default Permissions

Replace `admin@company.com` with your administrator's email address:

```bash
kubectl exec -it deploy/{{ app.slug }}-web -- rake factory:setup_permissions_defaults \
  'factory:add_owner[2,admin@company.com]'
```

## Studio V2 Features (Optional)

To enable Studio V2 features, ensure the following prerequisites are met:

1. You are running the latest platform image
2. An LLM Connection named `studio-v2` (lowercase) has been created
3. The connection is set as the default via **Settings > Connections**

Then run the following commands:

```bash
kubectl exec -it deploy/{{ app.slug }}-web -- rake studio:agent:install
kubectl exec -it deploy/{{ app.slug }}-web -- rake studio:tools:sync_crewai_tools
kubectl exec -it deploy/{{ app.slug }}-web -- rake studio:runner:install
```

## Accessing the Application

### Port Forwarding

For quick access or testing:

```bash
kubectl port-forward svc/{{ app.slug }}-web 2603:80
```

Then open [http://localhost:2603](http://localhost:2603) in your browser.

### Ingress

If you configured ingress during installation, access {{ app.name }} at your configured hostname (e.g., `https://{{ app.slug }}.company.com`).

### LoadBalancer

If using a LoadBalancer service, retrieve the external IP:

```bash
kubectl get svc {{ app.slug }}-web
```

## Verification

Confirm the installation is working correctly:

1. **Web UI access** — Open the application URL and confirm the login page loads
2. **Authentication** — Log in with your configured authentication provider
3. **Admin permissions** — Verify your account has administrator access
4. **Basic functionality** — Create a test crew or project to confirm operations are working
5. **Background workers** — Check that background workers are running:

```bash
kubectl logs deploy/{{ app.slug }}-worker --tail=50
```

## Next Steps

- [Configuration Guide](/configuration/guide) for production tuning
- [TLS Certificates](/configuration/tls) for securing your deployment
- [Database Configuration](/configuration/database) for external PostgreSQL setup
- [Monitoring & Metrics](/operations/monitoring) for observability
- [Backup & Restore](/operations/backup) for disaster recovery
