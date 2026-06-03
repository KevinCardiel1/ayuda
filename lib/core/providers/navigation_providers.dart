// File: lib/core/providers/navigation_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientTabProvider = StateProvider<int>((ref) => 0);
final adminTabProvider = StateProvider<int>((ref) => 0);
