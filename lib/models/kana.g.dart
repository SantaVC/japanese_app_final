// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kana.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kana _$KanaFromJson(Map<String, dynamic> json) => Kana(
      kana: json['kana'] as String,
      roumaji: json['roumaji'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$KanaToJson(Kana instance) => <String, dynamic>{
      'kana': instance.kana,
      'roumaji': instance.roumaji,
      'type': instance.type,
    };
