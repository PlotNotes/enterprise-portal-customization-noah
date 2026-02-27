---
title: Air Gap Installation
description: Install {{ app.name }} in disconnected environments
visible_when:
  entitlements:
    - isAirgapSupported
weight: 300
---

# Air Gap Installation

Install {{ app.name }} in environments without direct internet access.

<Warning>
Air gap installations require pre-downloading all bundles from a machine with internet access. Plan your transfer method before beginning.
</Warning>

<InstallStep stepNumber={1} title="Download the Air Gap Bundle">

From a machine with internet access, download the air gap bundle from this portal's [Release History](/installation/release-history) page.

The bundle includes:
- {{ app.name }} container images
- Kubernetes manifests
- Embedded cluster binaries (if using Linux install)

</InstallStep>

<InstallStep stepNumber={2} title="Transfer to Air Gap Environment">

Copy the bundle to your air gap server using your organization's approved transfer method (USB drive, bastion host, etc.).

</InstallStep>

<InstallStep stepNumber={3} title="Extract and Install">

```bash
tar xzf {{ app.slug }}-{{ release.version }}.airgap.tar.gz
cd {{ app.slug }}-{{ release.version }}
sudo ./install.sh --airgap
```

</InstallStep>

<InstallStep stepNumber={4} title="Wait for Image Loading">

<Note>
The installer automatically loads container images into the embedded registry. This may take **10-15 minutes** depending on hardware.
</Note>

</InstallStep>

## Updating in Air Gap

Download the new version's air gap bundle and run:

<CommandBlock command="sudo ./install.sh --airgap --upgrade" />

## Next Steps

- [Post-Installation steps](/installation/post-installation)
- [Configuration Guide](/configuration/guide)
