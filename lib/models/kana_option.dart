import 'kana.dart';
import 'package:flutter/material.dart';

class KanaOption {
  Kana kana;
  bool isEnabled;
  Color? color;

  KanaOption({
    required this.kana,
    this.isEnabled = true,
    this.color,
  });
}
