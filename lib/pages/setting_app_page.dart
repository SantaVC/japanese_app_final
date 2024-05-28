import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';

class SettingAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appSettings = Provider.of<AppSettings>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Setting App')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Enable Confetti Animation'),
            value: appSettings.enableConfetti,
            onChanged: (bool value) {
              appSettings.toggleConfetti();
            },
          ),
        ],
      ),
    );
  }
}
