import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/kana.dart';

class KanaDataLoader {
  final String jsonFilePath;

  KanaDataLoader({required this.jsonFilePath});

  Future<List<List<Kana>>> loadKanaData() async {
    final String jsonString = await rootBundle.loadString(jsonFilePath);
    List<dynamic> kanaDataJson = jsonDecode(jsonString);
    List<Kana> kanaData =
        kanaDataJson.map((item) => Kana.fromJson(item)).toList();
    return _createKanaGroups(kanaData);
  }

  List<List<Kana>> _createKanaGroups(List<Kana> kanaData) {
    List<List<Kana>> groups = [
      kanaData.sublist(0, 5), // a, i, u, e, o
      kanaData.sublist(5, 10), // ka, ki, ku, ke, ko
      kanaData.sublist(10, 15), // sa, shi, su, se, so
      kanaData.sublist(15, 20), // ta, chi, tsu, te, to
      kanaData.sublist(20, 25), // na, ni, nu, ne, no
      kanaData.sublist(25, 30), // ha, hi, fu, he, ho
      kanaData.sublist(30, 35), // ma, mi, mu, me, mo
      kanaData.sublist(35, 38), // ya, yu, yo
      kanaData.sublist(38, 43), // ra, ri, ru, re, ro
      [
        kanaData[43],
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[45],
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[44]
      ], // wa, wo, n
      kanaData.sublist(46, 51), // ga, gi, gu, ge, go
      kanaData.sublist(51, 56), // za, ji, zu, ze, zo
      kanaData.sublist(56, 61), // da, dji, dzu, de, do
      kanaData.sublist(61, 66), // ba, bi, bu, be, bo
      kanaData.sublist(66, 71), // pa, pi, pu, pe, po
      [
        kanaData[72], // kya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[73], // kyu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[74] // kyo
      ],
      [
        kanaData[75], // sha
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[76], // shu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[77] // sho
      ],
      [
        kanaData[78], // cha
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[79], // chu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[80] // cho
      ],
      [
        kanaData[81], // nya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[82], // nyu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[83] // nyo
      ],
      [
        kanaData[84], // hya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[85], // hyu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[86] // hyo
      ],
      [
        kanaData[87], // mya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[88], // myu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[89] // myo
      ],
      [
        kanaData[90], // rya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[91], // ryu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[92] // ryo
      ],
      [
        kanaData[93], // gya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[94], // gyu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[95] // gyo
      ],
      [
        kanaData[96], // ja
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[97], // ju
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[98] // jo
      ],
      [
        kanaData[99], // bya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[100], // byu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[101] // byo
      ],
      [
        kanaData[102], // pya
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[103], // pyu
        Kana(kana: '', roumaji: '', type: ''),
        kanaData[104] // pyo
      ]
    ];

    List<int> specialRows = [35];

    for (var groupIndex = 0; groupIndex < groups.length; groupIndex++) {
      List<Kana> group = groups[groupIndex];
      if (specialRows.contains(groupIndex * 5)) {
        List<Kana> newGroup =
            List.filled(5, Kana(kana: '', roumaji: '', type: ''));
        for (var item in group) {
          if (item.roumaji.startsWith('y')) {
            int index = 'aiueo'.indexOf(item.roumaji[1]);
            newGroup[index] = item;
          }
        }
        groups[groupIndex] = newGroup;
      } else {
        while (group.length < 5) {
          group.add(Kana(kana: '', roumaji: '', type: ''));
        }
      }
    }
    return groups;
  }
}

class HiraganaDataLoader extends KanaDataLoader {
  HiraganaDataLoader() : super(jsonFilePath: 'data/hiragana.json');
}

class KatakanaDataLoader extends KanaDataLoader {
  KatakanaDataLoader() : super(jsonFilePath: 'data/katakana.json');
}
