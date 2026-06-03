
// File: lib/core/providers/services_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/service.dart';
import 'package:floreria_ajolote/core/providers/firebase_provider.dart';

final servicesProvider = StreamProvider<List<Service>>((ref) {
  return ref.watch(firebaseProvider).getServices();
});

final serviceNotifierProvider = StateNotifierProvider<ServiceNotifier, AsyncValue<List<Service>>>((ref) {
  return ServiceNotifier(ref);
});

class ServiceNotifier extends StateNotifier<AsyncValue<List<Service>>> {
  final Ref _ref;

  ServiceNotifier(this._ref) : super(const AsyncValue.loading()) {
    _ref.watch(firebaseProvider).getServices().listen((services) {
      state = AsyncValue.data(services);
    });
  }

  Future<void> addService(Service service) async {
    await _ref.read(firebaseProvider).addService(service);
  }

  Future<void> updateService(Service service) async {
    await _ref.read(firebaseProvider).updateService(service);
  }

  Future<void> deleteService(String id) async {
    await _ref.read(firebaseProvider).deleteService(id);
  }
}
