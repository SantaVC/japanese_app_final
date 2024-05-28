// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:japanese_app/pages/test_setting_page.dart';
import '../loaders/kana_data_loader.dart';
import '../models/kana.dart';

class KatakanaPage extends StatefulWidget {
  @override
  _KatakanaPageState createState() => _KatakanaPageState();
}

class _KatakanaPageState extends State<KatakanaPage>
    with AutomaticKeepAliveClientMixin {
  final KatakanaDataLoader _dataLoader = KatakanaDataLoader();
  late Future<List<List<Kana>>> _dataFuture;
  late List<bool> checkedStatus;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _dataFuture = _dataLoader.loadKanaData();
    _dataFuture.then((data) {
      checkedStatus = List.filled(data.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<List<List<Kana>>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var floatingActionButton;
            if (shouldShowButton(snapshot.data!)) {
              floatingActionButton = FloatingActionButton(
                heroTag: 'katakanaFAB',
                onPressed: () {
                  Set<int> selectedIndexes = Set<int>();
                  for (int i = 0; i < checkedStatus.length; i++) {
                    if (checkedStatus[i]) selectedIndexes.add(i);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestSettingsPage(
                        selectedIndexes: selectedIndexes,
                        dataLoader: _dataLoader,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.navigate_next),
              );
            }
            return Scaffold(
              floatingActionButton: floatingActionButton,
              body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: buildKanaGroup(snapshot.data![index]),
                    value: checkedStatus[index],
                    onChanged: (bool? value) {
                      setState(() {
                        checkedStatus[index] = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  bool shouldShowButton(List<List<Kana>> data) {
    int countLessThanFour = 0;
    int totalSelected = 0;

    for (int i = 0; i < checkedStatus.length; i++) {
      if (checkedStatus[i]) {
        int numChars = data[i].where((kana) => kana.kana.isNotEmpty).length;
        totalSelected++;
        if (numChars < 4) {
          countLessThanFour++;
        }
      }
    }
    bool shouldShow =
        (totalSelected - countLessThanFour > 0) || (countLessThanFour >= 2);

    return shouldShow;
  }

  Widget buildKanaGroup(List<Kana> kanaGroup) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: kanaGroup
                .map((kana) => Text(kana.kana,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))
                .toList(),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: kanaGroup
                .map((kana) => Text(kana.roumaji,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])))
                .toList(),
          )
        ],
      ),
    );
  }
}
