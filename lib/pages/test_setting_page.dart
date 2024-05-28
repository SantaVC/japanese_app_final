import 'package:flutter/material.dart';
import 'package:japanese_app/loaders/kana_data_loader.dart';
import 'test_page.dart';

class TestSettingsPage extends StatefulWidget {
  final Set<int> selectedIndexes;
  final KanaDataLoader dataLoader;

  const TestSettingsPage(
      {Key? key, required this.selectedIndexes, required this.dataLoader})
      : super(key: key);

  @override
  _TestSettingsPageState createState() => _TestSettingsPageState();
}

class _TestSettingsPageState extends State<TestSettingsPage> {
  String testType = 'card'; // card or write
  String direction = 'kanaToRomanji'; // kanaToRomanji or romanjiToKana

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Settings'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Select Direction:',
                      style: Theme.of(context).textTheme.headline6),
                ),
                ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Kana to Romanji'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Romanji to Kana'),
                    ),
                  ],
                  isSelected: [
                    direction == 'kanaToRomanji',
                    direction == 'romanjiToKana'
                  ],
                  onPressed: (int index) {
                    setState(() {
                      direction =
                          index == 0 ? 'kanaToRomanji' : 'romanjiToKana';
                    });
                  },
                  color: Colors.grey,
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).primaryColor.withOpacity(0.7),
                  borderColor: Theme.of(context).primaryColor,
                  selectedBorderColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  borderWidth: 2,
                  constraints: BoxConstraints(minHeight: 40),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Select Test Type:',
                      style: Theme.of(context).textTheme.headline6),
                ),
                ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Card Test'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Write Test'),
                    ),
                  ],
                  isSelected: [testType == 'card', testType == 'write'],
                  onPressed: (int index) {
                    setState(() {
                      testType = index == 0 ? 'card' : 'write';
                    });
                  },
                  color: Colors.grey,
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).primaryColor.withOpacity(0.7),
                  borderColor: Theme.of(context).primaryColor,
                  selectedBorderColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  borderWidth: 2,
                  constraints: BoxConstraints(minHeight: 40),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPage(
                            selectedIndexes: widget.selectedIndexes,
                            dataLoader: widget.dataLoader,
                            testType: testType,
                            direction: direction,
                          ),
                        ));
                  },
                  child: Text('Start Test'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
