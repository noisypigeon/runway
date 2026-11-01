// Renders a Terragrunt plan or apply as PR comments (LIB-0026): one summary
// comment with a row per leaf, then detail comments with a section per leaf,
// packed within GitHub's comment cap and never truncated.
//
// Pure: no I/O. terragrunt-run.yml's comment step reads the run's files,
// calls render(), posts the bodies, then calls linkSummary() with the detail
// comments' URLs and edits the summary. Tested offline with node --test
// (render-run-comments.test.js).
'use strict';

// GitHub refuses a comment body over 65,536 characters; the rest is headroom
// for the markup around each section.
const BUDGET = 60000;

const WITHHELD = '(withheld: an identifier survived redaction; the encrypted plan artifact holds the full output)';

// `HH:MM:SS.mmm LEVEL [unit] terraform: message`, Terragrunt's own lines
// without the `terraform: `, and the run summary's lines with no unit at all.
const LINE = /^(?:\d\d:\d\d:\d\d\.\d+\s+)?(STDOUT|STDERR|INFO|WARN|ERROR|DEBUG|TRACE)\s+\[([^\]]+)\]\s?(?:terraform: )?(.*)$/;
const DEFERRED = /^=== (\S+): deferred until (.+) is applied ===$/;

// A unit as Terragrunt prints it, relative to the spoke: worktrees of the git
// filter (`/tmp/terragrunt-worktree-HEAD-123/terraform/…`), the base worktree
// of destroys, and the checkout itself are all stripped.
function normalizeUnit(raw, roots) {
  let unit = raw.trim();
  for (const root of roots) {
    const r = root.endsWith('/') ? root : `${root}/`;
    if (unit.startsWith(r)) unit = unit.slice(r.length);
  }
  unit = unit.replace(/^.*?\/terragrunt-worktree-[^/]+\//, '');
  unit = unit.replace(/^(\.\.\/)+/, '').replace(/^\.\//, '');
  return unit;
}

// Replaces every masked value with ***, as the job log does (LIB-0025 §4):
// output.txt is a file, which GitHub never masks.
function maskText(text, masked) {
  let out = text;
  const values = [...new Set(masked.filter((v) => v && v.length >= 3))].sort((a, b) => b.length - a.length);
  for (const v of values) out = out.split(v).join('***');
  return out;
}

// Identifiers are not secrets, so maskText never sees them, but a public
// comment must not carry them either (LIB-0054 §2): resource IDs, access key
// IDs, SRNs and bucket names. Each is replaced with `(redacted)`.
const REDACTED = '(redacted)';
// Shapes redacted anywhere in the text. A UUID, with or without a region
// prefix; a Scaleway access key ID; a Cloudflare-shaped 32-hex ID; a
// Backblaze-shaped 24- or 25-hex key ID. Word boundaries keep a 40-hex commit
// SHA intact.
const SHAPES = [
  /\b(?:[a-z]{2}-[a-z]{3}(?:-\d)?\/)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b/gi,
  /\bSCW[A-Z0-9]{17}\b/g,
  /\b[0-9a-f]{32}\b/gi,
  /\b[0-9a-f]{24,25}\b/gi,
];
// An attribute that names something: `name = …`, or `"name" = …` in outputs.
const ATTR = /^(\s*[-+~]?\s*)("?)([A-Za-z0-9_]+)\2(\s*=\s*)(.*)$/;
const ID_ATTR = /^(id|[A-Za-z0-9_]+_ids?|access_key|srn|arn|bucket|bucket_name)$/;
const BUCKET_ATTR = /^(name|[A-Za-z0-9_]*endpoint)$/;
// What type a line's resource is: a plan's `# addr will be created`, a
// `resource "type" "name" {` header, or an apply's `addr: Creating...`.
const TYPE_OF = [
  /^\s*# (?:\S+\.)?([a-z0-9]+_[a-z0-9_]+)\.[^.\s]+(?:\[[^\]]*\])? (?:will|must|has)/,
  /^\s*[-+~]?\s*(?:resource|data) "([a-z0-9_]+)" "/,
  /^(?:\S+\.)?([a-z0-9]+_[a-z0-9_]+)\.[^.\s:]+(?:\[[^\]]*\])?: /,
];

function redactShapes(text) {
  let out = text;
  for (const re of SHAPES) out = out.replace(re, REDACTED);
  return out;
}

function hasShape(text) {
  return SHAPES.some((re) => new RegExp(re.source, re.flags.replace('g', '')).test(text));
}

// Fails closed (LIB-0054 §3): a leaf in which an identifier survived
// redaction is withheld whole, rather than posted.
function guardPieces(pieces) {
  return pieces.some(hasShape) ? [WITHHELD] : pieces;
}

// A leaf's lines with every identifier redacted (LIB-0054 §2): by attribute
// (and every element of a list an ID attribute opens), by progress line, by
// shape, and a bucket's name wherever the line belongs to a bucket.
function redactLines(lines, unit) {
  const bucketLeaf = /(^|\/)(object-)?bucket(\/|$)|r2-bucket/.test(unit || '');
  let type = '';
  let inList = false;
  return lines.map((line) => {
    for (const re of TYPE_OF) {
      const t = line.match(re);
      if (t) { type = t[1]; break; }
    }
    let out = line.replace(/\[id=[^\]]*\]/g, `[id=${REDACTED}]`);
    if (inList) {
      if (/^\s*[-+~]?\s*\]/.test(out)) inList = false;
      else out = out.replace(/"[^"]*"/g, REDACTED);
    } else {
      const a = out.match(ATTR);
      if (a) {
        const name = a[3];
        const bucket = bucketLeaf || /bucket/.test(type);
        if (ID_ATTR.test(name) || (bucket && BUCKET_ATTR.test(name))) {
          const value = a[5].replace(/"[^"]*"/g, REDACTED);
          out = `${a[1]}${a[2]}${name}${a[2]}${a[4]}${value}`;
          if (/\[\s*$/.test(a[5])) inList = true;
        }
      }
    }
    return redactShapes(out);
  });
}

function parse(output, roots) {
  const leaves = new Map();
  const run = [];
  const deferredReasons = {};
  const leaf = (unit) => {
    if (!leaves.has(unit)) leaves.set(unit, []);
    return leaves.get(unit);
  };
  for (const line of output.split('\n')) {
    const d = line.match(DEFERRED);
    if (d) {
      deferredReasons[normalizeUnit(d[1], roots)] = d[2].split(', ').map((u) => normalizeUnit(u, roots));
      continue;
    }
    const m = line.match(LINE);
    if (!m) {
      if (line.trim() !== '') run.push(line);
      continue;
    }
    const [, level, rawUnit, message] = m;
    const unit = normalizeUnit(rawUnit, roots);
    if (level === 'STDOUT' || level === 'STDERR') leaf(unit).push(message);
    else if (level === 'WARN' || level === 'ERROR') leaf(unit).push(`${level}: ${message}`);
    // INFO, DEBUG and TRACE are Terragrunt's own narration, init's noise.
  }
  return { leaves, run, deferredReasons };
}

// +add ~change -destroy from a Terraform JSON plan; a replace counts as both.
// An output that changes counts as a change: an apply would still write it to
// state, so a plan that changes only outputs isn't settled (LIB-0027).
function countPlan(plan) {
  const c = { add: 0, change: 0, destroy: 0 };
  for (const rc of plan.resource_changes || []) {
    const a = (rc.change && rc.change.actions) || [];
    if (a.includes('create')) c.add++;
    if (a.includes('delete')) c.destroy++;
    if (a.length === 1 && a[0] === 'update') c.change++;
  }
  for (const oc of Object.values(plan.output_changes || {})) {
    const a = oc.actions || [];
    if (!(a.length === 1 && a[0] === 'no-op')) c.change++;
  }
  return c;
}

function countFromText(lines) {
  for (const l of lines) {
    let m = l.match(/Plan: (\d+) to add, (\d+) to change, (\d+) to destroy/);
    if (m) return { add: +m[1], change: +m[2], destroy: +m[3] };
    m = l.match(/Apply complete! Resources: (\d+) added, (\d+) changed, (\d+) destroyed/);
    if (m) return { add: +m[1], change: +m[2], destroy: +m[3] };
    if (/No changes\. /.test(l)) return { add: 0, change: 0, destroy: 0 };
  }
  return null;
}

const failed = (lines) => lines.some((l) => /^ERROR: |(^|│ )Error: /.test(l));
const counts = (c) => `+${c.add} ~${c.change} -${c.destroy}`;
const changes = (c) => c.add + c.change + c.destroy > 0;

// One row per leaf: what it will do, or did.
function classify(unit, ctx) {
  const lines = ctx.leaves.get(unit) || [];
  if (ctx.deferred.has(unit)) {
    const deps = ctx.deferredReasons[unit];
    return { kind: 'deferred', label: deps ? `deferred until ${deps.map((d) => `\`${d}\``).join(', ')}` : 'deferred', open: false };
  }
  if (failed(lines)) return { kind: 'failed', label: ctx.command === 'apply' ? '❌ failed' : '❌ error', open: true };
  const c = (ctx.jsonPlans[unit] && countPlan(ctx.jsonPlans[unit])) || countFromText(lines);
  const destroy = ctx.destroys.has(unit) ? 'destroy (removed from its unit file) ' : '';
  if (!c) return { kind: 'unknown', label: `${destroy}no result found`, open: true };
  if (ctx.command === 'apply') {
    return changes(c)
      ? { kind: 'changed', label: `${destroy}applied ${counts(c)}`, open: true }
      : { kind: 'unchanged', label: 'applied, no changes', open: false };
  }
  return changes(c)
    ? { kind: 'changed', label: `${destroy}${counts(c)}`, open: true }
    : { kind: 'unchanged', label: 'No changes', open: false };
}

const ORDER = { failed: 0, unknown: 1, changed: 2, deferred: 3, unchanged: 4 };

// The longest run of backticks in a body, plus one, so its fence can't close
// early.
function fenceFor(text) {
  const runs = text.match(/`+/g) || [];
  return '`'.repeat(Math.max(3, ...runs.map((r) => r.length + 1)));
}

function section(unit, row, body, part, parts) {
  const fence = fenceFor(body);
  // HTML, not backticks: GitHub doesn't reliably render Markdown in <summary>.
  const title = parts > 1 ? `<code>${unit}</code> (part ${part} of ${parts})` : `<code>${unit}</code>`;
  return [
    `<details${row.open ? ' open' : ''}><summary>${title} — ${row.label}</summary>`,
    '',
    fence,
    body,
    fence,
    '',
    '</details>',
    '',
  ].join('\n');
}

// A leaf's body in pieces that each fit one comment, split at line boundaries.
// A single line longer than the whole budget is cut, the only cut there is.
function splitBody(lines, room) {
  const pieces = [];
  let cur = [];
  let size = 0;
  for (let line of lines) {
    if (line.length > room) line = `${line.slice(0, room - 40)} …[line cut at ${room} characters]`;
    if (size + line.length + 1 > room && cur.length) {
      pieces.push(cur.join('\n'));
      cur = [];
      size = 0;
    }
    cur.push(line);
    size += line.length + 1;
  }
  pieces.push(cur.join('\n'));
  return pieces;
}

function render(input) {
  const roots = input.roots || [];
  const masked = input.masked || [];
  const parsed = parse(maskText(input.output || '', masked), roots);
  for (const [unit, lines] of parsed.leaves) parsed.leaves.set(unit, redactLines(lines, unit));
  parsed.run = redactLines(parsed.run, '');
  // A stage of a staged plan or apply (LIB-0042 §2) runs only its own units.
  // The destroys were applied with the first stage, so a later one leaves
  // out every destroy it didn't select rather than report it with no result.
  const stage = new Set((input.stage || []).map((u) => normalizeUnit(u, roots)));
  const ctx = {
    command: input.command,
    leaves: parsed.leaves,
    deferredReasons: parsed.deferredReasons,
    jsonPlans: Object.fromEntries(Object.entries(input.jsonPlans || {}).map(([u, p]) => [normalizeUnit(u, roots), p])),
    deferred: new Set((input.deferred || []).map((u) => normalizeUnit(u, roots))),
    destroys: new Set((input.destroys || []).map((u) => normalizeUnit(u, roots)).filter((u) => !stage.size || stage.has(u))),
  };
  const units = [...new Set([...ctx.leaves.keys(), ...Object.keys(ctx.jsonPlans), ...ctx.deferred, ...ctx.destroys])];
  const rows = units
    .map((unit) => ({ unit, ...classify(unit, ctx) }))
    .sort((a, b) => ORDER[a.kind] - ORDER[b.kind] || a.unit.localeCompare(b.unit));

  // Detail comments: sections packed in row order, a leaf too large for one
  // comment split across several.
  const header = (n) => `${input.marker}\n<!-- part -->\n#### Terragrunt ${input.command} \`${input.sha}\`, detail ${n}\n\n`;
  const room = BUDGET - header(99).length - 400;
  const details = [];
  const where = {};
  let cur = '';
  const flush = () => {
    if (cur) details.push(cur);
    cur = '';
  };
  // An unchanged leaf has no section, only a count in the summary; nor has
  // Terragrunt's own output, unless something went wrong.
  const shown = rows.filter((r) => r.kind !== 'unchanged');
  const quiet = rows.filter((r) => r.kind === 'unchanged');
  const troubled = !input.success || rows.some((r) => r.kind === 'failed' || r.kind === 'unknown');
  const withheld = [];
  const sections = shown.map((row) => [row, ctx.leaves.get(row.unit) || []]);
  if (troubled && parsed.run.length) sections.push([{ unit: 'Run', label: 'Terragrunt', open: false, kind: 'run' }, parsed.run]);
  for (const [row, lines] of sections) {
    const pieces = guardPieces(splitBody(lines.length ? lines : ['(no output)'], room));
    if (pieces[0] === WITHHELD) {
      row.label = `${row.label} (detail withheld)`;
      withheld.push(row.unit);
    }
    pieces.forEach((piece, i) => {
      const s = section(row.unit, row, piece, i + 1, pieces.length);
      if (cur.length + s.length > room) flush();
      if (where[row.unit] === undefined) where[row.unit] = details.length;
      cur += s;
    });
  }
  flush();
  const bodies = details.map((d, i) => d.replace(/^/, header(`${i + 1} of ${details.length}`)));

  // The summary: a count line, then a row for each leaf that changes, failed
  // or is deferred, with a link placeholder that linkSummary() fills in.
  // Unchanged leaves are counted, not listed.
  const link = (unit) => `{{detail:${where[unit]}}}`;
  const deferred = rows.filter((r) => r.kind === 'deferred').length;
  // Settled: a successful run in which every leaf is unchanged, with nothing
  // deferred, failed or without a result. An automatic re-plan that settles
  // has nothing left to apply, and merges (LIB-0027's amendment).
  const settled = Boolean(input.success) && rows.every((r) => r.kind === 'unchanged');
  const footer = settled && input.settledFooter ? input.settledFooter : input.footer || '';
  const tally = [
    `${rows.filter((r) => r.kind === 'changed').length} with changes`,
    `${quiet.length} with no changes`,
    `${rows.filter((r) => r.kind === 'failed' || r.kind === 'unknown').length} failed to ${input.command}`,
    ...(deferred ? [`${deferred} deferred`] : []),
  ].join(', ');
  const table = (rs) => ['| Leaf | Result | Detail |', '| --- | --- | --- |', ...rs.map((r) => `| \`${r.unit}\` | ${r.label} | ${link(r.unit)} |`)].join('\n');
  const summary = [
    input.marker,
    `### ${input.success ? '✅' : '❌'} Terragrunt ${input.command}`,
    '',
    `\`${input.sha}\`: ${tally}. [Full log](${input.runUrl}).`,
    ...(input.note ? ['', input.note] : []),
    '',
    shown.length ? table(shown) : '_Nothing changes._',
    '',
    where.Run !== undefined ? `Terragrunt's own output is in the Run section of ${link('Run')}.\n` : '',
    footer,
  ].join('\n');

  return { summary, details: bodies, settled, withheld };
}

// Fills the summary's {{detail:N}} placeholders with the detail comments'
// URLs, once they're posted.
function linkSummary(summary, urls) {
  return summary.replace(/\{\{detail:(\d+|undefined)\}\}/g, (_, n) => {
    const i = Number(n);
    return Number.isInteger(i) && urls[i] ? `[detail ${i + 1}](${urls[i]})` : '';
  });
}

module.exports = { render, linkSummary, countPlan, BUDGET, _test: { normalizeUnit, parse, countPlan, splitBody, maskText, fenceFor, redactLines, hasShape, guardPieces, WITHHELD } };
