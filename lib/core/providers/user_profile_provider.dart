
// File: lib/core/providers/user_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/user_profile.dart';
import 'package:floreria_ajolote/core/providers/firebase_provider.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return UserProfileNotifier(ref, authState);
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final Ref _ref;

  UserProfileNotifier(this._ref, AuthState authState) : super(const AsyncValue.loading()) {
    _processAuthState(authState);
  }

  void _processAuthState(AuthState authState) {
    if (authState is Authenticated) {
      state = AsyncValue.data(authState.userProfile);
    } else if (authState is Unauthenticated) {
      state = const AsyncValue.data(null);
    } else if (authState is AuthError) {
      state = AsyncValue.error(authState.message ?? "Unknown error", authState.stackTrace ?? StackTrace.current);
    } else { // AuthInitial or AuthLoading
      state = const AsyncValue.loading();
    }
  }

  Future<void> createUserProfile(UserProfile profile) async {
    // The AuthStateNotifier is listening for profile changes in Firestore.
    // When the profile is created/updated, the listener in AuthStateNotifier
    // will fire, which will update its state. Since userProfileProvider
    // watches authStateNotifierProvider, it will be rebuilt with the new state.
    await _ref.read(firebaseProvider).createUserProfile(profile);
  }
}
