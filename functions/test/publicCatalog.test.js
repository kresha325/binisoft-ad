const { describe, it } = require('node:test');
const assert = require('node:assert/strict');
const { serializeEmployeePublic, listPublicEmployees } = require('../publicCatalog');

function mockDoc(id, data) {
  return { id, data: () => data };
}

describe('serializeEmployeePublic', () => {
  it('returns only public fields (no email or phone)', () => {
    const out = serializeEmployeePublic(
      mockDoc('e1', {
        firstName: ' Ana ',
        lastName: 'Berisha',
        photoUrl: 'https://cdn.example/a.jpg',
        email: 'secret@x.com',
        phone: '+38344111222',
        salary: 500,
      }),
    );
    assert.deepEqual(out, {
      id: 'e1',
      firstName: 'Ana',
      lastName: 'Berisha',
      photoUrl: 'https://cdn.example/a.jpg',
    });
    assert.equal('email' in out, false);
    assert.equal('phone' in out, false);
    assert.equal('salary' in out, false);
  });
});

describe('listPublicEmployees', () => {
  it('includes only active and showOnSite employees', () => {
    const list = listPublicEmployees([
      mockDoc('a', {
        active: true,
        showOnSite: true,
        firstName: 'Z',
        lastName: 'Zeka',
      }),
      mockDoc('b', {
        active: true,
        showOnSite: false,
        firstName: 'Hidden',
        lastName: 'User',
      }),
      mockDoc('c', {
        active: false,
        showOnSite: true,
        firstName: 'Off',
        lastName: 'User',
      }),
      mockDoc('d', {
        active: true,
        showOnSite: true,
        firstName: 'Arben',
        lastName: 'Asllani',
      }),
    ]);
    assert.equal(list.length, 2);
    assert.equal(list[0].lastName, 'Asllani');
    assert.equal(list[1].lastName, 'Zeka');
  });
});
