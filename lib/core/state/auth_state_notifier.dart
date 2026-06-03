
// File: lib/core/state/auth_state_notifier.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/models/user_profile.dart';
import 'package:floreria_ajolote/core/firebase/firebase_service.dart';
import 'package:floreria_ajolote/core/providers/firebase_provider.dart';

abstract class AuthState {
  const AuthState();

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(User? user, UserProfile? userProfile) authenticated,
    required R Function() unauthenticated,
    required R Function(String? message) error,
  }) {
    if (this is AuthInitial) return initial();
    if (this is AuthLoading) return loading();
    if (this is Authenticated) {
      final auth = this as Authenticated;
      return authenticated(auth.user, auth.userProfile);
    }
    if (this is Unauthenticated) return unauthenticated();
    if (this is AuthError) {
      final err = this as AuthError;
      return error(err.message);
    }
    throw AssertionError('Unknown AuthState: $this');
  }
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final User? user;
  final UserProfile? userProfile;
  const Authenticated(this.user, this.userProfile);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String? message;
  final StackTrace? stackTrace;
  const AuthError(this.message, this.stackTrace);
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseService _firebaseService;

  AuthStateNotifier(this._firebaseAuth, this._firebaseService) : super(const AuthInitial()) {
    _firebaseAuth.authStateChanges().listen((user) async {
      if (user != null) {
        _firebaseService.getUserProfile(user.uid).listen((profile) {
          state = Authenticated(user, profile);
        });
      } else {
        state = const Unauthenticated();
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AuthLoading();
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
         _firebaseService.getUserProfile(user.uid).listen((profile) {
          state = Authenticated(user, profile);
        });
      } else {
         state = const Unauthenticated();
      }
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message, e.stackTrace);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String displayName, UserRole role) async {
    state = const AuthLoading();
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final newUserProfile = UserProfile(
          uid: user.uid,
          email: email,
          displayName: displayName,
          role: role,
        );
        await _firebaseService.createUserProfile(newUserProfile);
        _firebaseService.getUserProfile(user.uid).listen((profile) {
          state = Authenticated(user, profile);
        });
      } else {
        state = const Unauthenticated();
      }
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message, e.stackTrace);
    }
  }

  Future<void> registerClient({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
    required String direccion,
  }) async {
    state = const AuthLoading();
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final newUserProfile = UserProfile(
          uid: user.uid,
          email: email,
          displayName: nombre,
          role: UserRole.client,
          phoneNumber: telefono,
          apellido: apellido,
          direccion: direccion,
        );
        await _firebaseService.createUserProfile(newUserProfile);
        _firebaseService.getUserProfile(user.uid).listen((profile) {
          state = Authenticated(user, profile);
        });
      } else {
        state = const Unauthenticated();
      }
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message, e.stackTrace);
    }
  }

  Future<void> registerEmployee({
    required String email,
    required String password,
    required String nombre,
    required String puestoTrabajo,
    required String telefono,
    required String turno,
  }) async {
    state = const AuthLoading();
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final isAuthAdmin = puestoTrabajo.toLowerCase() == 'administrador' || puestoTrabajo.toLowerCase() == 'admin';
        final newUserProfile = UserProfile(
          uid: user.uid,
          email: email,
          displayName: nombre,
          role: isAuthAdmin ? UserRole.admin : UserRole.employee,
          phoneNumber: telefono,
          turno: turno,
          puestoTrabajo: puestoTrabajo,
        );
        await _firebaseService.createUserProfile(newUserProfile);
        _firebaseService.getUserProfile(user.uid).listen((profile) {
          state = Authenticated(user, profile);
        });
      } else {
        state = const Unauthenticated();
      }
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message, e.stackTrace);
    }
  }

  Future<void> signInWithEmailAndPasswordAndRole(
      String email, String password, List<UserRole> allowedRoles) async {
    state = const AuthLoading();
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        // Fetch the user profile once to validate the role
        final profile = await _firebaseService.getUserProfile(user.uid).first;
        if (profile != null && allowedRoles.contains(profile.role)) {
          _firebaseService.getUserProfile(user.uid).listen((profile) {
            state = Authenticated(user, profile);
          });
        } else {
          String errorMsg = 'Acceso denegado.';
          if (allowedRoles.contains(UserRole.employee)) {
             errorMsg = 'Error, este usuario no es un empleado.';
          } else if (allowedRoles.contains(UserRole.client)) {
             errorMsg = 'Error, este usuario es empleado, no cliente.';
          }
          await _firebaseAuth.signOut();
          state = AuthError(errorMsg, null);
        }
      } else {
        state = const Unauthenticated();
      }
    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message, e.stackTrace);
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    state = const AuthLoading();
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      final cred = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      // Re-set the state to Authenticated to remove loading state
       _firebaseService.getUserProfile(user.uid).listen((profile) {
          state = Authenticated(user, profile);
        });

    } on FirebaseAuthException catch (e) {
      state = AuthError(e.message, e.stackTrace);
      // Re-set state to authenticated if password change fails so UI doesn't get stuck on loading
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        _firebaseService.getUserProfile(user.uid).first.then((profile) {
           state = Authenticated(user, profile);
        });
      } else {
        state = const Unauthenticated();
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    state = const Unauthenticated();
  }
}

final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseService = ref.watch(firebaseProvider);
  return AuthStateNotifier(firebaseAuth, firebaseService);
});
