# LIB-0051: Serve the sites from Cloudflare R2, and retire the Pages shims

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-10-31.
- **Status**: Proposed. Amends:
  - DEV-0158, which moved noisypigeon.com back to GitHub Pages;
  - LIB-0031 and LIB-0034, whose site workloads deploy through a Pages shim
    repo;
  - LIB-0035 §3 and LIB-0037 §4, for `deployments.githubPages` and the shims'
    `pages.yml`.

  Keeps LIB-0006: every bucket is in the EU jurisdiction. Keeps LIB-0028: a
  workload's state stays in its Scaleway state bucket.

## Context

**The precedent.** noisypigeon.com has been served from a bucket before.
DEV-0132 put it on a Scaleway bucket behind a proxied Cloudflare record, and
DEV-0158 moved it back to GitHub Pages. DEV-0147 tried R2 first, for buckets
in general, and abandoned it over "a practical limitation" it didn't record.
The owner reports that the limitations which drove those reversals are now
lifted. This record doesn't assume which ones. §1 names every property the
sites need, and proves each one before any DNS moves.

**What Pages costs.** `actions/deploy-pages` deploys only the calling repo's
site (DEV-0156), so each site needs a shim repo of its own. That costs:

- **a cross-repo dispatch** for every deploy. It needs `BOT_GITHUB_TOKEN` to
  carry `actions: write` on both shims, and fails loudly when it doesn't
  (LIB-0047 §6);
- **a workflow version the shims lag on.** Their `site-pages.yml` is still at
  `workflows/v9.3.0`, so runway keeps `fetch-lib.sh` and `.lib-version`
  frozen for them (LIB-0050's amendment);
- **two imported Pages records per site,** owned by a workload but created
  by hand (LIB-0034 §2);
- **two repos** that hold nothing but a README and one workflow.

The sites are static Zola output, and every other resource the family runs
is in Terraform. A bucket and a custom domain in the workload's own leaves
replace all four.

## Decision

### 1. Preconditions, proven before any site moves

The sites need these properties over an R2 custom domain:

- **Directory index.** `/x/` and `/x` both serve `x/index.html`. Zola writes
  pretty URLs, and garden's redirect pages are directories.
- **The `terraform-get` meta tag.** A garden redirect page answers
  `GET /terraform/<p>/<m>/vX.Y.Z?terraform-get=1` with its HTML, and
  `terraform init` of a pinned short URL succeeds through it. Every
  `terraform init` in the family, runway's included, depends on this.
- **Not found.** A missing path serves `404.html` with status 404.
- **Static files.** The JSON Schemas, feeds and `static/` assets serve with
  correct content types.
- **TLS on both hosts.** The apex and `www` both serve, and `www` redirects
  to the apex.

`site-r2.yml` (§3) checks every one after each deploy. A test host proves them
before the first DNS move (§5). If any fails, the move stops there, and the
site stays on Pages.

### 2. `deployments.cloudflare` replaces `deployments.githubPages`

A site workload declares `deployments.cloudflare: {}` in the next workload
schema version. It implies these leaves, in the workload's own unit and its
zone's project, with state in the workload's Scaleway state bucket as today:

| Leaf | Module | What it is |
| --- | --- | --- |
| `cloudflare/bucket/site` | `cloudflare/bucket` | the site's bucket, EU jurisdiction, `exact_name` set to its host, so the bucket is named for what it serves |
| `cloudflare/r2-custom-domain/apex` and `…/www` | `cloudflare/r2-custom-domain` (new) | the bucket served on the workload's host, and on `www` |
| `cloudflare/ruleset/site` | `cloudflare/ruleset` | the index rewrite, and `www` to the apex |
| `cloudflare/api-token/site-deploy` | `cloudflare/api-token` | object write on that one bucket, read back by `site-r2.yml` |

- **The custom domain is a new, single-resource module.** `exact_name`
  names the bucket, but only `cloudflare_r2_custom_domain` serves it on a
  host. A plain record pointing at the bucket's endpoint reaches R2's
  authenticated S3 API, not public objects. The module is composed beside the
  bucket, as LIB-0038 composes deployers from single-resource modules.
- **The index rewrite is one transform rule:**
  - a path ending in `/` gets `index.html` appended;
  - a path with no `.` in its last segment gets `/index.html` appended.

  The second covers `?terraform-get=1` on a redirect page. A `404.html`
  answer comes from a custom error rule, if the provider exposes one.
  Otherwise §1's 404 check decides whether that blocks the move.
- **The deploy token stays in state.** `site-r2.yml` reads it with
  `terragrunt output`, so it adds no GitHub secret and no sops entry. R2's S3
  credentials are derived from it: the key ID is the token's ID, and the
  secret is the SHA-256 of its value.
- **`githubPages` stays valid** until both sites have moved. A workload
  declares one or the other.

### 3. runway builds and uploads its sites itself

- **A reusable `site-r2.yml`** replaces `site-pages.yml`. It:
  1. builds a site with Zola, resolving the theme;
  2. reads the deploy token;
  3. syncs `public/` to the bucket, deleting stale objects;
  4. checks §1 against the site's URL.
- **`sites.yml` calls it directly,** in runway, for each site whose files
  changed. It dispatches nothing.
- **Garden's generation commit deploys the same way,** and a theme release
  redeploys the blog in-repo instead of dispatching its shim.

### 4. Cutover, one site at a time, blog first

Each site moves in this order:

1. **Bucket and first deploy.** `deployments.cloudflare` lands beside
   `githubPages`, with the custom domain on a test host. The owner applies,
   and `site-r2.yml` deploys and checks §1 on the test host.
2. **The flip.** One PR moves the apex and `www` from the Pages records to
   the custom domain. It drops `githubPages`, and declares `removed {}` for
   the two imported Pages records, so their state goes without a destroy.
   The owner applies after reading the whole plan.
3. **Watch one release.** For garden, CI runs a `terraform init` of a pinned
   short URL.
4. **Archive the shim.**

**Rollback.** Until the shim is archived, rolling back is one DNS change back
to the Pages records.

### 5. Afterwards

Once both sites have moved:

- **`site-pages.yml`, `zola-site-pages.yml` and `site-dispatch.yml`** stop
  being called. They stay in their released versions, and are removed in the
  next `github/workflows` major.
- **`fetch-lib.sh`, `.lib-version` and the `/.lib-src/` ignore** have no
  caller. LIB-0052 deletes them.
- **`BOT_GITHUB_TOKEN`** no longer needs `actions: write` on any other repo.

## Consequences

- **No cross-repo dispatch is left in the family.** A site deploy is a job in
  runway.
- **Each site is a bucket and two custom domains, not a repo.** Everything
  that serves it is in its workload's leaves.
- **The sites cost R2 storage and egress,** both free at their size, where
  GitHub Pages cost nothing.
- **Each site's deploy token can write its bucket.** It lives only in state,
  and only `site-r2.yml` reads it.
- **Two decisions are reversed:** DEV-0158 and LIB-0031's shims. The old
  records stay as written.

## Out of scope

- **Moving Terraform state to R2.** State stays on Scaleway. This is a design
  boundary, not a deferral.
- **Serving the sites with Workers code.** They are static objects, with at
  most a transform rule and an error rule in front. This is a design
  boundary, not a deferral.
- **Deleting the shim repos.** They are archived, so their history and Pages
  settings stay readable. This is a design boundary, not a deferral.

## Verification

1. **Preconditions.** §1's checks pass on the test host, then on each real
   host after its flip.
2. **Short URLs.** After garden's flip, `terraform init` of a pinned
   `noisypigeon.garden/terraform/...` source succeeds.
3. **No dispatch.** `sites.yml` deploys both sites in runway, and no workflow
   dispatches across repos.
4. **The shims are archived.**

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
   - **Its token.** The zone's token gains `Zone Transform Rules Write` (the account-scoped `Transform Rules Write` is no use on a zone).
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
