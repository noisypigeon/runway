// Tests for scrub-run-comments.sh's selection (LIB-0054 §5). Run with:
//   node --test tools/github/scripts/
'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const path = require('node:path');

const script = path.join(__dirname, 'scrub-run-comments.sh');
const select = (comments) =>
  execFileSync('bash', [script, '--select'], { input: JSON.stringify(comments) }).toString().split('\n').filter(Boolean);

const bot = { login: 'github-actions[bot]' };
const fence = '```';

test('only the bot run comments that carry output are selected', () => {
  const comments = [
    { id: 1, user: bot, body: `<!-- terragrunt-plan -->\n<!-- part -->\n${fence}\nPlan: 1 to add\n${fence}` },
    { id: 2, user: bot, body: `<!-- terragrunt-apply -->\n<!-- part -->\n${fence}\nApply complete!\n${fence}` },
    { id: 3, user: bot, body: '<!-- terragrunt-plan -->\n### Terragrunt plan\n\n| Leaf | Result | Detail |' },
    { id: 4, user: bot, body: `<!-- terragrunt-plan -->\nTerragrunt plan, before LIB-0026\n${fence}\nresource\n${fence}` },
    { id: 5, user: { login: 'noisypigeon' }, body: `<!-- terragrunt-plan -->\n${fence}\nquoted\n${fence}` },
    { id: 6, user: bot, body: `Some other bot comment\n${fence}\ncode\n${fence}` },
    { id: 7, user: { login: 'noisypigeon' }, body: 'terragrunt apply' },
  ];
  assert.deepEqual(select(comments), ['1', '2', '4']);
});

test('an empty page selects nothing', () => {
  assert.deepEqual(select([]), []);
});
