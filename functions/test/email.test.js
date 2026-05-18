const test = require('node:test');
const assert = require('node:assert/strict');
const { buildTeamInviteEmail, deliverEmail, sendTeamInviteEmail, EMAIL_DISABLED } = require('../email');

test('email is disabled', () => {
  assert.equal(EMAIL_DISABLED, true);
});

test('buildTeamInviteEmail returns empty when disabled', () => {
  const { subject, html } = buildTeamInviteEmail({
    businessName: 'Jon Sport',
    role: 'manager',
    code: 'ABCD1234',
    assigned: false,
  });
  assert.equal(subject, '');
  assert.equal(html, '');
});

test('deliverEmail and sendTeamInviteEmail are no-ops', async () => {
  const delivered = await deliverEmail({ to: 'a@b.com', subject: 'x', html: 'y' });
  assert.equal(delivered.skipped, true);
  const invite = await sendTeamInviteEmail({ to: 'a@b.com', businessName: 'Shop', role: 'employee' });
  assert.equal(invite.skipped, true);
});
