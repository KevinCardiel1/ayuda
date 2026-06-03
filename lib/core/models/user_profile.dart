
// File: lib/core/models/user_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, client, employee }

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final String? photoURL;
  final String? phoneNumber;
  final String? apellido;
  final String? direccion;
  final String? turno;
  final String? puestoTrabajo;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoURL,
    this.phoneNumber,
    this.apellido,
    this.direccion,
    this.turno,
    this.puestoTrabajo,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      role: UserRole.values.firstWhere((e) => e.toString() == data['role'], orElse: () => UserRole.client),
      photoURL: data['photoURL'],
      phoneNumber: data['phoneNumber'],
      apellido: data['apellido'],
      direccion: data['direccion'],
      turno: data['turno'],
      puestoTrabajo: data['puestoTrabajo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role.toString(),
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'apellido': apellido,
      'direccion': direccion,
      'turno': turno,
      'puestoTrabajo': puestoTrabajo,
    };
  }
}

