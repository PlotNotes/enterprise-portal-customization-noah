---
title: Private Registry
description: Configure {{ app.name }} to pull images from a private Docker registry
weight: 200
---

# Using a Private Docker Registry

Configure {{ app.name }} to pull images from your private Docker registry for air-gapped or restricted network environments.

## Prerequisites

- Access to the {{ app.name }} Docker registry at `images.crewai.com`
- Valid credentials from the [customer portal](https://enterprise.crewai.com/crewai)
- A private Docker registry (ECR, ACR, GCR, Harbor, etc.)
- Docker CLI installed and configured

## Step 1: Authenticate

Use the credentials from your customer portal. These are the same tokens used for Helm registry authentication.

```bash
docker login images.crewai.com \
  --username {{ customer.email }} \
  --password {{ license.id }}
```

## Step 2: Pull Required Images

The following images are required for {{ app.name }}:

### Essential Images

| Image | Tag | Purpose |
|-------|-----|---------|
| `replicated-sdk-image` | `1.12.1` | Feature and license sync |
| `crewai-enterprise-platform` | `0.15.6` | Main application |
| `buildkit` | `v2026.0130.11` | Crew builds |
| `buildkit-rootless` | `v2026.0130.11` | Crew builds (rootless mode) |
| `crewai-enterprise-preinstalled-v2` | `latest` | Automation base |
| `python-base` | `latest` | Automation base |
| `busybox` | `latest` | Utility image |
| `redis` | `latest` | Caching and job queuing |

### Optional Images

| Image | Tag | Condition |
|-------|-----|-----------|
| `postgres` | `16` | If `postgresql.enabled=true` |
| `registry` | `2` | If `internalRegistry.enabled=true` |
| `minio` | `latest` | If `minio.enabled=true` |
| `crewai-oauth` | `0.2.5` | Built-in integration |

## Step 3: Tag Images for Your Registry

Tag each image for your private registry:

```bash
export YOUR_PRIVATE_REGISTRY="your-registry.example.com"

docker tag images.crewai.com/library/replicated-sdk-image:1.12.1 \
  $YOUR_PRIVATE_REGISTRY/crewai/replicated-sdk-image:1.12.1
```

Repeat for all required images.

## Step 4: Push Images

Push all tagged images to your private registry:

```bash
docker push $YOUR_PRIVATE_REGISTRY/crewai/replicated-sdk-image:1.12.1
```

Repeat for all images.

## Step 5: Configure Helm Values

### Generic Private Registry

```yaml
global:
  imageRegistry: "your-registry.example.com"
  imageNamePrefixOverride: "crewai/"

image:
  registries:
    - host: "your-registry.example.com"
      username: "your-username"
      password: "your-password"

envVars:
  CONTAINER_REGISTRY_HOSTNAME: "your-registry.example.com"
```

{{#if entitlements.isAWSEnabled}}
### AWS ECR

```yaml
global:
  imageRegistry: "123456789012.dkr.ecr.us-west-2.amazonaws.com"
  imageNamePrefixOverride: "crewai/"

image:
  registries:
    - host: "123456789012.dkr.ecr.us-west-2.amazonaws.com"
      credHelper: "ecr-login"

envVars:
  CONTAINER_REGISTRY_HOSTNAME: "123456789012.dkr.ecr.us-west-2.amazonaws.com"
```
{{/if}}

{{#if entitlements.isAzureEnabled}}
### Azure Container Registry

```yaml
global:
  imageRegistry: "myregistry.azurecr.io"
  imageNamePrefixOverride: "crewai/"

image:
  registries:
    - host: "myregistry.azurecr.io"
      username: "myregistry"
      password: "<access-token>"

envVars:
  CONTAINER_REGISTRY_HOSTNAME: "myregistry.azurecr.io"
```
{{/if}}

## Automation Script

Save the following as `mirror-images.sh` to automate the pull/tag/push workflow:

```bash
#!/bin/bash
set -euo pipefail

SOURCE_REGISTRY="images.crewai.com"
TARGET_REGISTRY="${YOUR_PRIVATE_REGISTRY}"
TARGET_PREFIX="crewai"

declare -A IMAGES=(
  ["library/replicated-sdk-image:1.12.1"]="replicated-sdk-image:1.12.1"
  ["library/crewai-enterprise-platform:0.15.6"]="crewai-enterprise-platform:0.15.6"
  ["library/buildkit:v2026.0130.11"]="buildkit:v2026.0130.11"
  ["library/buildkit-rootless:v2026.0130.11"]="buildkit-rootless:v2026.0130.11"
  ["library/crewai-enterprise-preinstalled-v2:latest"]="crewai-enterprise-preinstalled-v2:latest"
  ["library/python-base:latest"]="python-base:latest"
  ["library/busybox:latest"]="busybox:latest"
  ["library/redis:latest"]="redis:latest"
)

for SOURCE_IMAGE in "${!IMAGES[@]}"; do
  TARGET_IMAGE="${IMAGES[$SOURCE_IMAGE]}"
  echo "Mirroring ${SOURCE_IMAGE} -> ${TARGET_PREFIX}/${TARGET_IMAGE}"
  docker pull "${SOURCE_REGISTRY}/${SOURCE_IMAGE}"
  docker tag "${SOURCE_REGISTRY}/${SOURCE_IMAGE}" "${TARGET_REGISTRY}/${TARGET_PREFIX}/${TARGET_IMAGE}"
  docker push "${TARGET_REGISTRY}/${TARGET_PREFIX}/${TARGET_IMAGE}"
done

echo "All images mirrored successfully."
```

```bash
chmod +x mirror-images.sh
./mirror-images.sh
```

## Verification

After deploying, verify all pods are pulling from your private registry:

```bash
kubectl get pods -l app.kubernetes.io/name={{ app.slug }} \
  -o jsonpath='{range .items[*]}{.spec.containers[*].image}{"\n"}{end}'
```

## Troubleshooting

If pods show `ImagePullBackOff` errors, check:

- **Registry credentials** — Ensure the credentials in your Helm values are correct
- **Image names and tags** — Verify the tagged images match the expected paths in your private registry

```bash
kubectl describe pod <pod-name> -n {{ app.slug }}
```
