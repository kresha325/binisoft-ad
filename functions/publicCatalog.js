/**
 * Public shop catalog serializers (testable, no Firebase deps).
 */

function serializeEmployeePublic(doc) {
  const data = doc.data();
  return {
    id: doc.id,
    firstName: String(data.firstName || '').trim(),
    lastName: String(data.lastName || '').trim(),
    photoUrl: data.photoUrl || '',
  };
}

/** Active + showOnSite only; sorted by last name. */
function listPublicEmployees(docs) {
  return docs
    .filter((doc) => doc.data().active === true && doc.data().showOnSite === true)
    .map((doc) => serializeEmployeePublic(doc))
    .sort((a, b) => {
      const ln = String(a.lastName).localeCompare(String(b.lastName), 'sq');
      if (ln !== 0) return ln;
      return String(a.firstName).localeCompare(String(b.firstName), 'sq');
    });
}

module.exports = {
  serializeEmployeePublic,
  listPublicEmployees,
};
