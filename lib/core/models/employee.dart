// File: lib/core/models/employee.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final String role;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    this.email = '',
    this.phoneNumber,
    this.photoUrl,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'],
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
