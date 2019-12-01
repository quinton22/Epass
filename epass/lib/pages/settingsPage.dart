import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _groupValue = 0;
  Future<SharedPreferences> prefsFuture;

  @override
  void initState() {
    super.initState();
    prefsFuture = SharedPreferences.getInstance();
    prefsFuture.then((prefs) {
      int val = (prefs.getInt('settings') ?? 0);
      _changeValue(val);
    });
  }

  _changeValue(int val) {
    setState(() {
      _groupValue = val;
    });
    prefsFuture.then((prefs) async => prefs.setInt('settings', val));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RadioListTile(
              title: Text('Biometrics'),
              value: 0,
              groupValue: _groupValue,
              onChanged: _changeValue,
            ),
            RadioListTile(
              title: Text('Password and Text'),
              value: 1,
              groupValue: _groupValue,
              onChanged: _changeValue,
            )
          ],
        ),
      ),
    );
  }
}
