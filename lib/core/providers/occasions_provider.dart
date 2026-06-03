
// File: lib/core/providers/occasions_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/occasion.dart';
import 'package:floreria_ajolote/core/providers/firebase_provider.dart';

final occasionsProvider = StreamProvider<List<Occasion>>((ref) {
  return ref.watch(firebaseProvider).getOccasions();
});

final occasionNotifierProvider = StateNotifierProvider<OccasionNotifier, AsyncValue<List<Occasion>>>((ref) {
  return OccasionNotifier(ref);
});

class OccasionNotifier extends StateNotifier<AsyncValue<List<Occasion>>> {
  final Ref _ref;

  OccasionNotifier(this._ref) : super(const AsyncValue.loading()) {
    _ref.watch(firebaseProvider).getOccasions().listen((occasions) {
      state = AsyncValue.data(occasions);
    });
  }

  Future<void> addOccasion(Occasion occasion) async {
    await _ref.read(firebaseProvider).addOccasion(occasion);
  }

  Future<void> updateOccasion(Occasion occasion) async {
    await _ref.read(firebaseProvider).updateOccasion(occasion);
  }

  Future<void> deleteOccasion(String id) async {
    await _ref.read(firebaseProvider).deleteOccasion(id);
  }
}
