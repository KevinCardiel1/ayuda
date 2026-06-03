// File: lib/core/models/occasion.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'occasion.freezed.dart';
part 'occasion.g.dart';

@freezed
class Occasion with _$Occasion {
  const Occasion._();

  const factory Occasion({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    @Default([]) List<String> applicableCategories,
  }) = _Occasion;

  factory Occasion.fromJson(Map<String, dynamic> json) => _$OccasionFromJson(json);

  factory Occasion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Occasion.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id');
  }
}
