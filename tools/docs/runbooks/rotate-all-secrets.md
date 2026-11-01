# Rotate every secret

This replaces every credential the spoke holds, in the order
[LIB-0054](../adr/LIB-0054-redact-identifiers-and-rotate-secrets.md) §6 sets.
Run it after identifier redaction has shipped and the old run comments have
been swept (§§1–5), so that no new key's ID is ever posted.

Each credential is named here by its role. Never paste a value, an ID or a
bucket name anywhere: not in a PR, a commit, an issue or a chat.

## Before you start

- **Nothing is waiting to be applied.** A plan's archive is encrypted to the
  age key it was made with, so finish or close every PR with a pending plan
  first.
- **You have the current age key locally,** where sops finds it (for example
  `~/.config/sops/age/keys.txt`).
- **List the copies outside Terraform** of each credential below, such as
  pigeon-cli's runtime configuration or a laptop's CLI profile. Each must be
  updated in the same sitting as its rotation, or it stops working.

## 1. The sops age key

1. **Make a new key,** locally, and never commit it:

   ```bash
   age-keygen -o ~/.config/sops/age/new-key.txt
   ```

   Add its contents to `~/.config/sops/age/keys.txt`, beside the old key, so
   sops can use either.
2. **Add its public recipient** beside the old one in every
   `creation_rules` entry of `.config/sops.yaml`, comma-separated.
3. **Re-encrypt every file to both recipients:**

   ```bash
   for f in terraform/secrets/*.enc workloads/*/secrets.yaml workloads/*/*/secrets.workload.yaml; do [ -f "$f" ] && sops --config .config/sops.yaml updatekeys -y "$f"; done
   ```

4. **Open a PR with that change.** Its plan should show `No changes.` for
   every leaf it plans. Merge it.
5. **Swap the GitHub secret.** In the repo's settings, under Secrets and
   variables, then Actions, set `SOPS_AGE_KEY` to the new private key.
6. **Remove the old recipient** from `.config/sops.yaml`, then run the step 3
   loop again.
7. **Give every file a new data key,** so the old age key, together with
   history, opens nothing new:

   ```bash
   for f in terraform/secrets/*.enc workloads/*/secrets.yaml workloads/*/*/secrets.workload.yaml; do [ -f "$f" ] && sops --config .config/sops.yaml rotate -i "$f"; done
   ```

8. **Open a PR with steps 6 and 7.** Its plan proves that CI decrypts with
   the new key alone, and should show `No changes.` Merge it.
9. **Destroy the old private key** in every place it was kept.

## 2. Every Terraform-managed key

This step replaces each unit's deployer key, the job-runner and self-delete
keys, and the Cloudflare tokens and Backblaze keys the spoke creates.

1. **Run a canary on one zone.** In `.config/spoke.hcl`, set:

   ```hcl
   rotation_generations = { "zones/pigeon.dev" = 1 }
   ```

   Open a PR and read the whole plan. It should show only replacements of
   that zone's keys and their timestamps, each created before the old one is
   destroyed. Apply it. The stages plan by themselves.
2. **Check the canary.** A `terragrunt plan` comment on the next PR should
   show the zone at `No changes.`, signed in with its new keys.
3. **Rotate the rest.** Set `rotation_generation = 1`, and remove
   `rotation_generations`. Read the whole plan:
   - it should show only key replacements, plus the timestamps and
     `terraform_data.rotation` beside them;
   - it should touch nothing near the cold buckets.

   Apply it.
4. **Update every copy outside Terraform** of a rotated key.
5. **Check the run path:** run `run-scaleway-job` with
   `unit_dir=workloads/private/data-ops` and `job=version`. It should succeed,
   signed in with the new job-runner key.

The next full rotation is one bump: `rotation_generation = 2`.

## 3. The hand-made secrets in `terraform/secrets/`

These are the credentials no Terraform leaf creates:

- the spoke's Scaleway key;
- the Cloudflare and Backblaze keys, and their break-glass pairs;
- the shared environment values.

For each one:

1. **Create its replacement** at the provider, with the same scope as the old
   one.
2. **Save it** with `mise run secrets-edit <file>`, where `<file>` is one of
   `terraform`, `scaleway`, `cloudflare`, `backblaze`, `env`,
   `cloudflare_breakglass` or `backblaze_breakglass`.
3. **Open a PR.** Its plan, signed in with the new value, should show
   `No changes.` Merge it.
4. **Revoke the old credential** at the provider.

**Rotate each break-glass pair on a different day from its primary,** so one
credential in each pair is always known good (LIB-0014).

## 4. The GitHub secrets

For `BOT_GITHUB_TOKEN`, `GH_ADMIN_TOKEN` and `CARGO_REGISTRY_TOKEN`, one at a
time:

1. **Regenerate it** with the same scopes.
2. **Replace it** under the repo's Actions secrets.
3. **Prove it works.** Run a workflow that uses it:
   - `template-release.yml` or `garden-generate.yml` for the bot token;
   - `interaction-limits-monthly.yml` for the admin token;
   - the next crate release for the registry token.
4. **Revoke the old one.**

## 5. Workload secrets

For each `secrets.yaml` or `secrets.workload.yaml`:

1. **Rotate each value at its source.**
2. **Save it** with `mise run secrets-edit-workload <workload>`.
3. **Open a PR.** Its plan should show only the changes that value implies.

## Done

Rotation is done when all of these hold:

- each provider lists only the new credentials;
- a plan of every unit shows `No changes.`;
- `run-scaleway-job` succeeds.
