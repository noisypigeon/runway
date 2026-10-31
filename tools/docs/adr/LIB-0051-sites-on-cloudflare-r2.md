
## Amendments

### 2026-10-31: as built

Where this entry and the text above disagree, this entry is what runs.

1. **The rulesets are the zone's, not the workload's (§2).**
   - **Why.** A zone holds one entrypoint ruleset per phase (LIB-0036 §3), and
     the workload's token can't write one.
   - **What the zone implies.** A zone whose host workload declares
     `deployments.cloudflare` implies two rulesets:
     - `sites-root`, an `http_request_transform` rule that serves each site's
       `/` from `/index.html`;
     - `sites-www`, for a site that serves `www`, an
       `http_request_dynamic_redirect` from `www` to the apex.
   - **Its token.** The zone's token gains `Transform Rules Write`.
   - **The conflict guard.** A zone can't have both `sites-www` and an
     `apexRedirect`, which would need the same entrypoint.
   - **Where it's read from.** `root.hcl` and `resolve-workloads.sh` each read
     the host workloads' files for this. `terragrunt-run` plans a changed
     workload's zone with it.
2. **Directory pages are objects, not a rewrite.**
   - **How.** `site-r2.yml` uploads every `x/index.html` also as `x` and
     `x/`. Only `/` needs a rule.
   - **Why.** The no-extension rewrite §2 described would need a regex, which
     Cloudflare's free plan doesn't offer. A plain "no `.` in the path" test
     would have missed every module version page, since `v1.2.3` contains
     dots.
   - **Deleting stale objects.** That happens only after the new ones are up.
3. **The workload side.** `deployments.cloudflare` takes optional `hosts`,
   names in its zone. Without it, the site is served on its host's names:
   `@` and `www` for an apex host.
   - **The test host.** A host Pages also serves is refused, which is how the
     test host in §4 step 1 works: `hosts: [r2-test]` beside `githubPages`.
   - **Implied entries.** The custom domains and the token are implied under
     `cloudflare._implied`, so a workload file can't declare them directly.
   - **Ordering.** A custom domain depends on `cloudflare/bucket/site`, so it
     plans once the bucket exists.
   - **The site token** is minted with the spoke's breakglass token, as the
     workload's own is.
4. **The Pages records are destroyed at the flip, not `removed {}` (§4).** R2
   claims a hostname only when no record holds it, so the flip's plan destroys
   the two Pages CNAMEs and creates the custom domains. The owner reads that
   plan whole. The site is down between the two, for one apply.
5. **The 404 is R2's.** A missing key answers 404, which is what §1 checks.
   The body is R2's, not the site's `404.html`.
6. **The workload schema isn't bumped yet.** CI's checks are
   `resolve-workloads.sh`'s, which accept `deployments.cloudflare`. An editor
   validating against `schemas/workload/v6.json` flags it until the schema
   catches up.
