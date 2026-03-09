---
title: Helm Support Bundles
visible_when:
  entitlements:
    - isHelmInstallEnabled
---

# Helm Support Bundles

Collect and view support bundles from your Helm-based Kubernetes installations.

## CLI Based Collection

For Helm installations, you'll need to use the kubectl support-bundle plugin to collect diagnostics.

### Step 1: Install the support-bundle plugin

First, install the kubectl support-bundle plugin using krew:

<CommandBlock command="kubectl krew install support-bundle" />

If you don't have krew installed, follow the instructions at [https://krew.sigs.k8s.io/docs/user-guide/setup/install/](https://krew.sigs.k8s.io/docs/user-guide/setup/install/).

### Step 2: Generate a support bundle

Run the following command to collect diagnostics from your Kubernetes cluster:

<CommandBlock command="kubectl support-bundle --load-cluster-specs" />

This command will automatically detect and collect diagnostics from your Kubernetes cluster. The support bundle will be saved as a .tar.gz file in your current directory. While sensitive information is automatically redacted, we recommend reviewing the contents before uploading for analysis.
