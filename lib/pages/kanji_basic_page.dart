import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/kanji.dart';

class KanjiBasicPage extends StatelessWidget {
  Future<List<Kanji>> loadKanjiData() async {
    final String jsonString = await rootBundle.loadString('data/kanji.json');
    List<dynamic> kanjiDataJson = jsonDecode(jsonString);
    List<Kanji> kanjiData =
        kanjiDataJson.map((item) => Kanji.fromJson(item)).toList();
    return kanjiData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kanji Basic')),
      body: FutureBuilder<List<Kanji>>(
        future: loadKanjiData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              debugPrint('Snapshot Error: ${snapshot.error}');
              return Center(
                  child: Text("Error loading kanji data: ${snapshot.error}"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Kanji kanji = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              kanji.kanji ?? "N/A",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'Meaning: ${kanji.meaning ?? "Not available"}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(
                                    'Reading:\nOnyomi: ${kanji.onyomi}\nKunyomi: ${kanji.kunyomi}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
