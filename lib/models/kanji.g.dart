// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kanji _$KanjiFromJson(Map<String, dynamic> json) => Kanji(
      number: (json['number'] as num).toInt(),
      kanji: json['kanji'] as String?,
      onyomi: json['onyomi'] as String? ?? '',
      kunyomi: json['kunyomi'] as String? ?? '',
      meaning: json['meaning'] as String?,
    );

Map<String, dynamic> _$KanjiToJson(Kanji instance) => <String, dynamic>{
      'number': instance.number,
      'kanji': instance.kanji,
      'onyomi': instance.onyomi,
      'kunyomi': instance.kunyomi,
      'meaning': instance.meaning,
    };
