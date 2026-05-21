enum EmploymentType {
  fullTime('full_time'),
  partTime('part_time'),
  contract('contract'),
  internship('internship'),
  temporary('temporary'),
  other('other');

  const EmploymentType(this.storageValue);
  final String storageValue;

  static EmploymentType? fromStorage(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final t in EmploymentType.values) {
      if (t.storageValue == raw) return t;
    }
    return EmploymentType.other;
  }
}
