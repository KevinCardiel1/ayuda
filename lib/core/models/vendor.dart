// File: lib/core/models/vendor.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  final String id;
  final String name;
  final String contact;
  final String phone;
  final String email;

  Vendor({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    required this.email,
  });

  factory Vendor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Vendor(
      id: doc.id,
      name: data['name'] ?? '',
      contact: data['contact'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'contact': contact,
      'phone': phone,
      'email': email,
    };
  }
}
