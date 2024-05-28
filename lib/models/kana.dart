import 'package:json_annotation/json_annotation.dart';

part 'kana.g.dart';

@JsonSerializable()
class Kana {
  String kana;
  String roumaji;
  String type;

  Kana({required this.kana, required this.roumaji, required this.type});

  factory Kana.fromJson(Map<String, dynamic> json) => _$KanaFromJson(json);
  Map<String, dynamic> toJson() => _$KanaToJson(this);
}
