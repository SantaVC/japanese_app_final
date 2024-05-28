// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'kanji_basic_page.dart';
import 'setting_app_page.dart';
import 'kana_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'images/bgwelcome.png',
              fit: BoxFit.cover,
            ),
          ),
          positionedButton(context, 'KANA', KanaPage(), 0.2, false),
          positionedButton(
              context, 'KANJI BASIC', KanjiBasicPage(), 0.35, true),
          positionedButton(context, 'SETTING', SettingAppPage(), 0.5, false),
        ],
      ),
    );
  }

  Widget positionedButton(BuildContext context, String title, Widget page,
      double top, bool isLeftAligned) {
    BorderSide borderSide = BorderSide(color: Colors.black, width: 2);
    Size screenSize = MediaQuery.of(context).size;

    double fontSize = screenSize.width * 0.06;
    double padding = screenSize.width * 0.08;

    return Positioned(
      top: screenSize.height * top,
      left: isLeftAligned ? null : null,
      right: isLeftAligned ? null : 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: borderSide,
            bottom: borderSide,
            left: isLeftAligned ? BorderSide.none : borderSide,
            right: isLeftAligned ? borderSide : BorderSide.none,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            ),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: padding, vertical: padding),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
