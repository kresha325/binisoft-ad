import 'package:web/web.dart' as web;

import '../constants/app_constants.dart';

void openDashboardUrl() {
  web.window.location.href = '${AppConstants.dashboardWebUrl}/';
}
