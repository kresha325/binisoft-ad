import 'package:flutter_test/flutter_test.dart';

import 'package:business_dashboard/core/utils/email_validation.dart';

void main() {
  test('validateAccountEmail normalizes and accepts valid', () {
    expect(validateAccountEmail('  User@Mail.COM '), 'user@mail.com');
  });

  test('validateAccountEmail rejects invalid', () {
    expect(validateAccountEmail(''), isNull);
    expect(validateAccountEmail('not-an-email'), isNull);
  });
}
