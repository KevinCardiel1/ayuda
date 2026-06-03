// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OccasionImpl _$$OccasionImplFromJson(Map<String, dynamic> json) =>
    _$OccasionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      applicableCategories: (json['applicableCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OccasionImplToJson(_$OccasionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'applicableCategories': instance.applicableCategories,
    };
