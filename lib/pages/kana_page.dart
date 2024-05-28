import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'hiragana_page.dart';
import 'katakana_page.dart';

class KanaPage extends StatefulWidget {
  @override
  _KanaPageState createState() => _KanaPageState();
}

class _KanaPageState extends State<KanaPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(keepPage: true);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kana Learning')),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HiraganaPage(),
          KatakanaPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('images/iconhi.png', width: 24, height: 24),
            label: 'Hiragana',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/iconka.png', width: 24, height: 24),
            label: 'Katakana',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
