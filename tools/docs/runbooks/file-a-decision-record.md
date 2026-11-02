# File, amend or read a decision record

New decision records are discussions in runway's **ADR** category. Every
record filed before LIB-0056's move, LIB-0001 to LIB-0056 and the frozen
`DEV-` records, is in **ADR Archive**.
Each step below is a `gh` command, so it works from a terminal or an agent.

Everything posted is public and permanent, and edit history keeps every
version. Never paste plan output, bucket names, key IDs or secrets.

## Look up the repository and category IDs

```sh
gh api graphql -f query='
  { repository(owner: "noisypigeon", name: "runway") {
      id
      discussionCategories(first: 25) { nodes { id name } } } }'
```

Export the results:

```sh
export REPO_ID=<repository id>
export CATEGORY_ID=<the "ADR" category id>
```

## Find the next number

The number is max+1 over both categories' titles (LIB-0056 §1).

```sh
gh api graphql --paginate -f query='
  query($endCursor: String) {
    repository(owner: "noisypigeon", name: "runway") {
      discussions(first: 100, after: $endCursor) {
        pageInfo { hasNextPage endCursor }
        nodes { title } } } }' \
  --jq '.data.repository.discussions.nodes[].title' \
  | grep -oE '^LIB-[0-9]{4}' | sort | tail -1
```

Until the move in LIB-0056 §5 is done, also check `tools/docs/adr/` at `main`
and take the larger.

## File a record

1. Draft it locally as `LIB-NNNN.md`.
   - The first line is `# LIB-NNNN: <title>`.
   - Then come the `Author`, `Date` and `Status` lines. The author is always
     `Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).`
   - The sections are `## Context` / `## Decision` / `## Consequences` /
     `## Out of scope`, then optionally `## Verification`.
   - There is no frontmatter.
2. Post it. The title is the H1, and the body is everything after it:

   ```sh
   title=$(head -1 LIB-NNNN.md | sed 's/^# //')
   tail -n +2 LIB-NNNN.md | sed '1{/^$/d}' > body.md
   gh api graphql -F repositoryId="$REPO_ID" -F categoryId="$CATEGORY_ID" \
     -F title="$title" -F body=@body.md -f query='
     mutation($repositoryId: ID!, $categoryId: ID!, $title: String!, $body: String!) {
       createDiscussion(input: {repositoryId: $repositoryId, categoryId: $categoryId,
                                title: $title, body: $body}) {
         discussion { number url } } }' --jq '.data.createDiscussion.discussion.url'
   ```

3. File an `out-of-scope` issue for each genuinely deferred item (DEV-0031),
   and append its link to the bullet (see [Amend a record](#amend-a-record)).
4. The PRs that do the work name the record in their branch and title
   (`feat(lib-NNNN): …`) and link the discussion in their body.

## Read a record

```sh
gh api graphql -F number=<discussion number> -f query='
  query($number: Int!) {
    repository(owner: "noisypigeon", name: "runway") {
      discussion(number: $number) { title body } } }' \
  --jq '.data.repository.discussion | "# \(.title)\n\n\(.body)"'
```

To find a record by its ID:

```sh
gh api graphql -f query='
  { search(type: DISCUSSION, first: 5,
           query: "repo:noisypigeon/runway in:title LIB-0047") {
      nodes { ... on Discussion { number title url } } } }'
```

## Amend a record

1. Pull the body down with [Read a record](#read-a-record), keeping only
   `.body`, into `body.md`.
2. Edit it:
   - add a dated entry under `## Amendments`, `### YYYY-MM-DD: <what changed>`;
   - update the `Status` line.
3. Push it back, using the discussion's node ID:

   ```sh
   id=$(gh api graphql -F number=<n> -f query='
     query($number: Int!) { repository(owner: "noisypigeon", name: "runway") {
       discussion(number: $number) { id } } }' --jq '.data.repository.discussion.id')
   gh api graphql -F id="$id" -F body=@body.md -f query='
     mutation($id: ID!, $body: String!) {
       updateDiscussion(input: {discussionId: $id, body: $body}) { discussion { url } } }'
   ```

4. Comment one line naming the amendment, so it shows on the timeline:

   ```sh
   gh api graphql -F id="$id" -f body='Amended YYYY-MM-DD: <one line>.' -f query='
     mutation($id: ID!, $body: String!) {
       addDiscussionComment(input: {discussionId: $id, body: $body}) { comment { url } } }'
   ```

Accepting, superseding or rejecting a record is the same edit to its `Status`
line.

An archived `LIB-` record in **ADR Archive** is amended the same way, in
place. Never edit a `DEV-` record. It is frozen (LIB-0017, LIB-0056 §4).
