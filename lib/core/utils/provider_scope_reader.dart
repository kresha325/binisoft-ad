import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider container valid after async gaps or in [State.dispose].
ProviderContainer providerScopeOf(BuildContext context) =>
    ProviderScope.containerOf(context, listen: false);
