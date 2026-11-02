# LIB-0056: Decision records move to GitHub Discussions

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-11-01.
- **Status**: Proposed. Amends LIB-0017 (§1's filing target, §2's archive
  location) and LIB-0047's placement of the records under the library. The
  last record filed as a file.

## Context

The family's decision records are files: 55 `LIB-` records in
`tools/docs/adr/` and 122 frozen `DEV-` records in `tools/docs/adr/archive/`.
A record is filed by a `docs(adr):` PR, and every amendment, acceptance and
issue link is another PR.

That made sense while a record was text that moved with the code it
governed. Three things have changed.

1. **The records don't move with the code any more.** `tools/docs/` is not a
   released unit (LIB-0050). No tag carries a record, no consumer pins one,
   and no script reads one. The directory is versioned only by `main`.
2. **The directory has moved three times.** The records went from
   `noisypigeon/library`'s `docs/adr/` to runway's `adr/` (LIB-0047), to
   `lib/docs/adr/` (LIB-0049), then to `tools/docs/adr/` (LIB-0050). Each move
   broke every `blob/main/` link to a record, and left pointers to chase
   through other repos' `CLAUDE.md` (LIB-0017 Context, item 4). pigeon-cli's
   still names runway's `adr/`.
3. **A PR is the wrong tool for a record's life.** Over a quarter of the
   `adr` lines in the two changelogs (24 of 86) are housekeeping. They
   accept a record, record its verification, add an amendment, or link an
   out-of-scope issue. Each
   of those is a branch, a PR, a CI run and a changelog line for a prose
   edit. There is no human reviewer (`CLAUDE.md`, Dev cycle), so the PR
   reviews nothing. And a record has no place to discuss it: a question
   about LIB-0047 is an issue, a PR comment, or nothing.

GitHub Discussions is a repository feature built for long-lived, titled,
Markdown documents with a comment thread. A discussion keeps its URL as long
as the repository does, whatever happens to the tree. Its body's edit
history is kept. It can be searched, and linked from issues and PRs. An
announcement-format category limits who can open a discussion to the
repository's maintainers, while anyone can comment.

## Decision

### 1. A record is a discussion

Every `LIB-` record is a discussion in noisypigeon/runway's **Decision
records** category. The category uses the announcement format, so only a
maintainer can file a record, and anyone can comment on one.

- **The title is the record's old H1,** `LIB-NNNN: <title>`. The ID is the
  record's identity. The discussion number is only its address.
- **The body is the record without its H1.** It keeps the `Author`, `Date`
  and `Status` lines, and the `## Context` / `## Decision` /
  `## Consequences` / `## Out of scope` sections, then optionally
  `## Verification` and `## Amendments`. There is still no frontmatter.
- **The number is max+1 over the category's titles.** No `LIB-` number is
  reused, and none is skipped.
- **A record is linked by its discussion URL,** and cited by its ID, as
  before.

### 2. Filing, amending and accepting don't take a PR

- **Filing** is opening the discussion. A record is live, and `Proposed`,
  from the moment it is filed. Draft it locally first, as before, then post
  it.
- **Amending** is editing the body: a dated entry under `## Amendments`, and
  an updated `Status` line, as before. Then add a comment that names the
  amendment in one line, so the change shows on the discussion's timeline and
  reaches anyone watching it. GitHub keeps every earlier version of the body.
- **Accepting, superseding or rejecting** is editing the `Status` line.
- **The work a record decides is still a PR.** Its branch and title name the
  record (`feat(lib-NNNN): …`), and its body links the discussion.

`tools/docs/runbooks/file-a-decision-record.md` is the procedure, with the
`gh` commands.

### 3. Out-of-scope issues (DEV-0031) are unchanged, except for the link

A genuinely deferred item still gets a runway issue labelled `out-of-scope`.
Its link is appended to the bullet by editing the body, and the issue's body
links the discussion. `tools/github/scripts/adr-issue.sh` stays as it is:
it edits files, and pigeon-cli's `CLI-` records are still files.

### 4. The `DEV-` archive moves too, to its own category

The 122 `DEV-` records go to a second announcement-format category,
**Decision records archive**, titled by their H1s. LIB-0017's rules for
the archive still hold.

- **Frozen.** A `DEV-` record's body is never edited after it moves.
- **Closed.** No new `DEV-` number is issued.
- **Archiving is not superseding** (LIB-0017 §4). A record keeps the
  `Status` it was filed with.

`archive/README.md` becomes the category's first discussion, **The
`DEV-` archive**, pinned. The numbers used twice (`0136`, `0138`, `0156`) stay
told apart by their titles.

Keeping the two corpora in separate categories keeps the live list to records
that can still change.

### 5. The move is mechanical and the bodies are verbatim

1. **Freeze.** No PR touches `tools/docs/adr/` once the move starts. Call the
   commit on `main` at that point `F`.
2. **Post.** A script posts every record at `F` as a discussion: the `LIB-`
   records in number order, this one included, then the archive's README,
   then the `DEV-` records in number order. It paces its calls to stay under
   GitHub's content-creation limits. For each record:
   - the title is its H1;
   - the body is the rest of the file, byte for byte, except that each
     relative link to a file in the tree becomes a permalink to that file at
     `F`;
   - the body ends with one line, `Moved from <permalink to the file at F>
     by LIB-0056.`
   The longest record, LIB-0001, is 46 KB, inside the 64 KB body limit.
3. **Check** (see `## Verification`).
4. **Delete.** One PR deletes `tools/docs/adr/`, except for a `README.md`
   that points to the two categories and to `F`. The same PR drops the `adr`
   rule from `root-changelog.yml`'s precedence, drops the interim sentences
   from `CLAUDE.md` and `tools/README.md`, and turns every remaining in-tree
   link to a record file (such as `tools/README.md`'s link to LIB-0001) into a
   link to its discussion.

Citations are never rewritten (LIB-0017 §3). A cross-link between two records
is rewritten only to the permalink at `F`, not to the target's discussion,
so every link still resolves after the move and the move needs no ID-to-URL
table.

### 6. Until the move, new records are already discussions

From this record's acceptance:

- a new record is filed as a discussion, numbered max+1 over the category's
  titles and the files at `F`;
- an amendment to a record still in `tools/docs/adr/` waits for the move, or
  is filed on the record's discussion once it exists.

### 7. What the owner does once, by hand

GitHub's API can't create a discussion category. Before the move, the owner:

1. turns on Discussions (Settings → General → Features);
2. creates **Decision records** and **Decision records archive**, both in
   the announcement format;
3. deletes, or leaves empty, the default categories, which this record
   doesn't use.

### 8. Where the pointers change

- **runway's `CLAUDE.md`, Decision records:** records live in the category,
  filed by the runbook.
- **`tools/README.md`, Decision records:** the same.
- **LIB-0017 §1, "filed here":** this repository's Decision records category,
  not its `docs/adr/`. Recorded as an amendment on LIB-0017's discussion once
  it exists.
- **pigeon-cli's `CLAUDE.md`:** its pointer to runway's records names the
  category, in a pigeon-cli PR. Its own `CLI-` records stay files in its
  `adr/` (LIB-0017 §5).

## Consequences

- **A record's address stops depending on the tree.** The next move of
  `tools/` breaks no link to a record.
- **Housekeeping stops costing a PR.** Accepting a record, recording its
  verification, adding an amendment or linking an issue is an edit, with no
  branch, CI run or changelog line.
- **A record gets a thread.** Questions and follow-ups sit under the record
  they are about.
- **The records leave git.** A record is no longer in a clone, at a tag, or
  in `git log`. Its history is GitHub's edit history, not commits. It is
  lost if the repository is deleted, which would also lose its issues and
  PRs.
- **A record is no longer reviewed as a diff.** With no human reviewer, that
  costs nothing today. A future reviewer would comment on the discussion.
- **The `adr` changelog tag ends.** A record no longer produces a changelog
  line, so the root `CHANGELOG.md` no longer lists records as they land.
  The discussion list, newest first, is that list now.
- **Agents read records over the API.** An agent working in runway reads a
  record with `gh` instead of from the tree. The runbook gives the command.
- **`blob/main/tools/docs/adr/<file>` links break once, at step 4.** The
  pointer `README.md` and the permalinks at `F` cover them. Garden's generated
  pages link the old repositories' copies, which this record doesn't touch.
- **Everything posted is public and permanent,** as it was in git. Edit
  history keeps every version of a body, so the `CLAUDE.md` rule against
  pasting plan output, bucket names, key IDs or secrets applies to every edit
  and comment.

## Out of scope

- **A periodic export of both categories into git or object storage,** as a
  backup and an offline copy for agents. Deferred until losing GitHub is a
  risk worth paying for.
- **Status labels or closing superseded records.** The `Status` line stays the
  only status. A second one would drift.
- **Rewriting cross-links to point to discussions.** The permalinks at `F`
  resolve, and the ID finds the live record.
- **pigeon-cli's `CLI-` records.** They stay files, by LIB-0017 §5.
- **Rendering the records on garden.** Nothing renders them today.

## Verification

- Each category holds exactly one discussion per file at `F`: 56 `LIB-`
  records, and 122 `DEV-` records plus the pinned README.
- Every title equals its file's H1, and every ID at `F` appears in exactly one
  title, except the three `DEV-` numbers used twice.
- Every body, with its permalinks turned back into relative links and its
  last line dropped, is byte-identical to its file at `F`.
- LIB-0001, the longest record, renders in full.
- The deletion PR's `root-changelog` run writes its line under `repo`, not
  `adr`.
