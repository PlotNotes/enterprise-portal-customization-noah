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

<Prerequisites title="Before You Begin">

- Review the [System Requirements](/installation/requirements)
- A machine with internet access for downloading bundles
- An approved transfer method to your air gap environment (USB drive, bastion host, etc.)
- Ensure your firewall rules allow the transfer method you plan to use

</Prerequisites>

---

{{#if entitlements.isEmbeddedClusterDownloadEnabled}}
## Linux Air Gap Installation

Install {{ app.name }} on a Linux server in an air-gapped environment using Embedded Cluster.

<LinuxAirgapInstallAssets stepNumber={1} />

<InstallStep stepNumber={4} title="Configure {{ app.name }}">

Once the installer finishes, open the admin console in your browser:

<CommandBlock command="echo https://$(hostname):8800" />

Log in with the password you set during installation and complete the setup wizard.

</InstallStep>

<InstallStep stepNumber={5} title="Verify the Installation">

Confirm all services are running:

<CommandBlock command="{{ app.slug }} status" />

<Note>
In air gap environments, initial image loading can take **10-15 minutes**. If pods show `ImagePullBackOff`, wait for the embedded registry to finish loading.
</Note>

</InstallStep>

{{/if}}

{{#if entitlements.isHelmAirgapEnabled}}
## Helm Air Gap Installation

Install {{ app.name }} on your existing Kubernetes cluster using Helm in an air-gapped environment.

<HelmAirgapInstallAssets stepNumber={1} />

<InstallStep stepNumber={4} title="Create Values Override">

Create a `my-values.yaml` file for your air gap environment:

<CommandBlock>
global:
  replicated:
    imageRegistry: your-private-registry.example.com
  domain: {{ app.slug }}.example.com
</CommandBlock>

<Tip>
See the [Helm Values Reference](/content/reference/helm-values) for the full list of configurable values.
</Tip>

</InstallStep>

<InstallStep stepNumber={5} title="Verify the Installation">

Check that all pods are running:

<CommandBlock>
kubectl -n {{ app.slug }} get pods
kubectl -n {{ app.slug }} get svc
</CommandBlock>

Wait for all pods to reach `Running` state. In air gap environments this may take longer than usual as images are pulled from your private registry.

</InstallStep>

{{/if}}

---

## Updating in Air Gap

Download the new version's air gap bundle from the [Release History](/installation/release-history) page and repeat the installation steps above with the new bundle.

<InstanceName />

## Next Steps

- [Post-Installation steps](/installation/post-installation)
- [Configuration Guide](/content/configuration/configuration)
