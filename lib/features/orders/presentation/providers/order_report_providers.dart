import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/order_report_export_service.dart';

final orderReportExportServiceProvider =
    Provider((ref) => const OrderReportExportService());
