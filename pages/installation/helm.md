---
title: Helm Installation
visible_when:
  entitlements:
    - isHelmInstallEnabled
---

# Helm Installation

Install your application on a Kubernetes cluster using Helm charts. Read the docs or select your deployment preferences.

## Requirements

Review the following prerequisites before installing.

- Kubernetes cluster v1.26 or later
- Helm 3.x installed on your workstation
- kubectl configured with cluster access
- StorageClass available for persistent volumes

<Tip title="Before You Begin">
Run `kubectl get sc` to confirm a default StorageClass is available. If no default is set, the installation will fail when creating persistent volume claims.
</Tip>

## Choose an installation

<PendingInstallSelector method="helm" />

<NewInstall method="helm" />

<InstanceName method="helm" />

## Configuration

Customize the options below. The install commands will update automatically based on your selections.

<KubernetesDistribution />
<NetworkAvailability installType="helm" />
<RegistryAccess />
<VersionSelector installType="helm" />
<HelmReleaseImages />

## Install

<Note>
The commands below are personalized to your selected installation. If you switch installations or rename your instance, the commands will update automatically.
</Note>

<HelmInstallStep step="export_credentials" stepNumber={10} charts="purrfect-match" />

<HelmInstallStep step="create_values_file" stepNumber={20} charts="purrfect-match" />

<HelmInstallStep step="install_chart" stepNumber={30} charts="purrfect-match" />

## Install (per-step with chart filter)

<HelmInstallStep step="install_chart" stepNumber={101} charts="purrfect-match" />

<HelmInstallStep step="export_credentials" stepNumber={102} charts="purrfect-match" />

## Airgap Install

<HelmAirgapInstallAssets stepNumber={50} charts="purrfect-match" />

## Update

<HelmUpdateAssets stepNumber={1} charts={["purrfect-match"]} />

## Post-Install

<Note>
After installation, verify that all pods are running with `kubectl get pods -n <namespace>` before proceeding to post-installation configuration.
</Note>

See the post-installation documentation for next steps including configuring TLS, setting up backups, and connecting to your identity provider.
