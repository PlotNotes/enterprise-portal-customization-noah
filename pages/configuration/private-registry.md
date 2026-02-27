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

<CommandBlock command="docker login images.crewai.com \
  --username {{ customer.email }} \
  --password {{ license.id }}" />

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

<CommandBlock command="export YOUR_PRIVATE_REGISTRY=&quot;your-registry.example.com&quot;

docker tag images.crewai.com/library/replicated-sdk-image:1.12.1 \
  $YOUR_PRIVATE_REGISTRY/crewai/replicated-sdk-image:1.12.1" />

Repeat for all required images.

## Step 4: Push Images

Push all tagged images to your private registry:

<CommandBlock command="docker push $YOUR_PRIVATE_REGISTRY/crewai/replicated-sdk-image:1.12.1" />

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

<CommandBlock command="#!/bin/bash
set -euo pipefail

SOURCE_REGISTRY=&quot;images.crewai.com&quot;
TARGET_REGISTRY=&quot;${YOUR_PRIVATE_REGISTRY}&quot;
TARGET_PREFIX=&quot;crewai&quot;

declare -A IMAGES=(
  [&quot;library/replicated-sdk-image:1.12.1&quot;]=&quot;replicated-sdk-image:1.12.1&quot;
  [&quot;library/crewai-enterprise-platform:0.15.6&quot;]=&quot;crewai-enterprise-platform:0.15.6&quot;
  [&quot;library/buildkit:v2026.0130.11&quot;]=&quot;buildkit:v2026.0130.11&quot;
  [&quot;library/buildkit-rootless:v2026.0130.11&quot;]=&quot;buildkit-rootless:v2026.0130.11&quot;
  [&quot;library/crewai-enterprise-preinstalled-v2:latest&quot;]=&quot;crewai-enterprise-preinstalled-v2:latest&quot;
  [&quot;library/python-base:latest&quot;]=&quot;python-base:latest&quot;
  [&quot;library/busybox:latest&quot;]=&quot;busybox:latest&quot;
  [&quot;library/redis:latest&quot;]=&quot;redis:latest&quot;
)

for SOURCE_IMAGE in &quot;${!IMAGES[@]}&quot;; do
  TARGET_IMAGE=&quot;${IMAGES[$SOURCE_IMAGE]}&quot;
  echo &quot;Mirroring ${SOURCE_IMAGE} -> ${TARGET_PREFIX}/${TARGET_IMAGE}&quot;
  docker pull &quot;${SOURCE_REGISTRY}/${SOURCE_IMAGE}&quot;
  docker tag &quot;${SOURCE_REGISTRY}/${SOURCE_IMAGE}&quot; &quot;${TARGET_REGISTRY}/${TARGET_PREFIX}/${TARGET_IMAGE}&quot;
  docker push &quot;${TARGET_REGISTRY}/${TARGET_PREFIX}/${TARGET_IMAGE}&quot;
done

echo &quot;All images mirrored successfully.&quot;" />

<CommandBlock command="chmod +x mirror-images.sh
./mirror-images.sh" />

## Verification

After deploying, verify all pods are pulling from your private registry:

<CommandBlock command="kubectl get pods -l app.kubernetes.io/name={{ app.slug }} \
  -o jsonpath='{range .items[*]}{.spec.containers[*].image}{&quot;\n&quot;}{end}'" />

## Troubleshooting

If pods show `ImagePullBackOff` errors, check:

- **Registry credentials** — Ensure the credentials in your Helm values are correct
- **Image names and tags** — Verify the tagged images match the expected paths in your private registry

<CommandBlock command="kubectl describe pod <pod-name> -n {{ app.slug }}" />
