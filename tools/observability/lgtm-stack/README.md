# observability/lgtm-stack

[`pigeon-cli`](https://github.com/noisypigeon/pigeon-cli)'s local observability
stack: Loki, Grafana and Prometheus, hoisted from that repo by its CLI-0161
(the stack itself is its CLI-0128). Versioned as
`observability/lgtm-stack/vX.Y.Z`, continuing `observability/pigeon-cli/vX.Y.Z`
(LIB-0050).

| Service | Port | What it does |
| --- | --- | --- |
| Prometheus | 9090 | Scrapes a bare-metal `pigeon` run's `/metrics` at `host.docker.internal:9091`. |
| Loki | 3100 | Stores the JSONL log Promtail ships. |
| Promtail | — | Tails `~/Library/Application Support/pigeon/logs` (macOS). |
| Grafana | 3000 | Renders [`dashboards/pigeon-cli`](../dashboards/pigeon-cli) over both. |

The dashboard is not copied here. Grafana mounts
`../dashboards/pigeon-cli` from the same checkout, so a stack version
renders the dashboard as it was at that commit. Its node-exporter disk panel
stays empty locally, because nothing here runs a node-exporter.

## Consuming a version

From a checkout of the tag, run
`docker compose -f tools/observability/lgtm-stack/docker-compose.yml up -d`.
pigeon-cli's `mise run observability-up` does this from its fetched clone of
runway, at the version it pins.

## Editing

Change the stack here and open a PR. The `release:*` label sets the bump.
