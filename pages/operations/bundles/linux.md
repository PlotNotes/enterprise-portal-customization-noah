---
title: Linux Support Bundles
visible_when:
  entitlements:
    - isEmbeddedClusterDownloadEnabled
---

# Linux Support Bundles

Collect and view support bundles from your Linux (Embedded Cluster) installations.

## UI Based Collection

Log in to the Admin Console and go to the Troubleshoot tab. Click Analyze to generate a support bundle. After the analysis completes, you can download the bundle or send it directly to the vendor if enabled.

## CLI Based Collection

To collect diagnostics about your environment, SSH onto a controller node and run the following command:

<CommandBlock command="sudo ./{{app.slug}} support-bundle" />

The support bundle will be saved as a .tar.gz file in your current directory. While sensitive information is automatically redacted, we recommend reviewing the contents before uploading for analysis.
