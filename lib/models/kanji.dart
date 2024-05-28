import 'package:json_annotation/json_annotation.dart';

part 'kanji.g.dart';

@JsonSerializable()
class Kanji {
  final int number;
  final String? kanji;
  @JsonKey(defaultValue: '')
  final String onyomi;
  @JsonKey(defaultValue: '')
  final String kunyomi;
  final String? meaning;

  Kanji({
    required this.number,
    this.kanji,
    this.onyomi = '',
    this.kunyomi = '',
    this.meaning,
  });

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);
  Map<String, dynamic> toJson() => _$KanjiToJson(this);
}
