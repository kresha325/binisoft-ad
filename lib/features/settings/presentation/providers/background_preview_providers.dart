import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live overlay opacity while adjusting the slider (before Firestore save completes).
final backgroundOverlayPreviewProvider = StateProvider<double?>((ref) => null);
