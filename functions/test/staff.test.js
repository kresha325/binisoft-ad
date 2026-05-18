const { describe, it } = require('node:test');
const assert = require('node:assert/strict');
const { normalizeEmail, generateInviteCode, STAFF_ROLES } = require('../staff');

describe('staff helpers', () => {
  it('normalizeEmail trims and lowercases', () => {
    assert.equal(normalizeEmail('  User@Mail.COM '), 'user@mail.com');
    assert.equal(normalizeEmail(''), '');
  });

  it('generateInviteCode returns 8 uppercase hex chars', () => {
    const code = generateInviteCode();
    assert.match(code, /^[0-9A-F]{8}$/);
  });

  it('STAFF_ROLES contains manager and employee', () => {
    assert.equal(STAFF_ROLES.has('manager'), true);
    assert.equal(STAFF_ROLES.has('employee'), true);
    assert.equal(STAFF_ROLES.has('admin'), false);
  });
});
