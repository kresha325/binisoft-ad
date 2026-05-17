import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/email_dispatch_service.dart';

final emailDispatchServiceProvider = Provider<EmailDispatchService>((ref) {
  return EmailDispatchService();
});
