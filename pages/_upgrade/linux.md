## Upgrading to {{release.version}}

<Note title="Before you begin">
  Snapshot your cluster state before upgrading. See the operations guide for details.
</Note>

<UpgradePath fromBelow="2.0.0">
  <Warning title="Major version upgrade">
    Upgrading across the 1.x to 2.x boundary requires draining nodes first:
    <CommandBlock command="kubectl drain <node> --ignore-daemonsets" />
  </Warning>
</UpgradePath>

<UpgradePath fromBelow="3.0.0" fromAtLeast="2.0.0">
  <Note title="2.x to 3.x">
    Run the embedded cluster preflight before applying:
    <CommandBlock command="sudo ./app preflight" />
  </Note>
</UpgradePath>

<UpgradePath fromAtLeast="3.0.0">
  <Tip title="In-place upgrade">
    Versions 3.x and later support in-place upgrades with zero downtime.
  </Tip>
</UpgradePath>

## Apply the upgrade

<LinuxUpdateAssets stepNumber={1} />
