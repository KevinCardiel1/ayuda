// File: lib/core/models/event.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String userId;
  final String name;
  final String type;
  final DateTime date;
  final double budget;

  Event({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.date,
    required this.budget,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      budget: (data['budget'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'type': type,
      'date': Timestamp.fromDate(date),
      'budget': budget,
    };
  }
}
