
// File: lib/core/providers/firebase_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/firebase/firebase_service.dart';

final firebaseProvider = Provider<FirebaseService>((ref) => FirebaseService());
