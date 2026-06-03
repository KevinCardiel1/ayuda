// File: lib/core/models/batch.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Batch {
  final String id;
  final String productId;
  final String vendorId;
  final int quantity;
  final DateTime entryDate;
  final DateTime expiryDate;
  final double unitCost;

  Batch({
    required this.id,
    required this.productId,
    required this.vendorId,
    required this.quantity,
    required this.entryDate,
    required this.expiryDate,
    required this.unitCost,
  });

  factory Batch.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Batch(
      id: doc.id,
      productId: data['productId'] ?? '',
      vendorId: data['vendorId'] ?? '',
      quantity: data['quantity'] ?? 0,
      entryDate: (data['entryDate'] as Timestamp).toDate(),
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      unitCost: (data['unitCost'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'vendorId': vendorId,
      'quantity': quantity,
      'entryDate': Timestamp.fromDate(entryDate),
      'expiryDate': Timestamp.fromDate(expiryDate),
      'unitCost': unitCost,
    };
  }
}
