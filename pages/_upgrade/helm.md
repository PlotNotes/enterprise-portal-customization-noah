## Upgrading to {{release.version}}

<Note title="Before you begin">
  Take a backup of your application data before upgrading.
</Note>

<UpgradePath fromBelow="2.0.0">
  <Warning title="Major version upgrade">
    You are upgrading across the 1.x to 2.x boundary. Run the migration script first:
    <CommandBlock command="kubectl apply -f https://example.com/migrations/v1-to-v2.yaml" />
  </Warning>
</UpgradePath>

<UpgradePath fromBelow="3.0.0" fromAtLeast="2.0.0">
  <Note title="2.x to 3.x">
    Database schema changes require running:
    <CommandBlock command="kubectl exec -it my-app -- /usr/bin/db-migrate" />
  </Note>
</UpgradePath>

<UpgradePath fromAtLeast="3.0.0">
  <Tip title="Minor upgrade">
    No migrations required for upgrades from 3.x.
  </Tip>
</UpgradePath>

## Apply the upgrade

<HelmUpdateAssets stepNumber={1} charts={["purrfect-match"]} />
