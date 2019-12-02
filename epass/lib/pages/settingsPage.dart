import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _dropdownValue = 0;
  int _groupValue = 0;
  Future<SharedPreferences> prefsFuture;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    prefsFuture = SharedPreferences.getInstance();
    prefsFuture.then((prefs) {
      int val = (prefs.getInt('settings') ?? 0);
      _changeValue(val);
      int val2 = (prefs.getInt('settings2') ?? 30);
      int val3 = (prefs.getInt('settings3') ?? 0);
      _controller.text = val2.toString();
      _dropdownValue = val3;
    });
  }

  _changeValue(int val) {
    setState(() {
      _groupValue = val;
    });
    prefsFuture.then((prefs) => prefs.setInt('settings', val));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Password Refresh',
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        focusNode: _focusNode,
                        onEditingComplete: () {
                          prefsFuture.then((prefs) => prefs.setInt(
                              "settings2", int.parse(_controller.text)));
                          _controller.clearComposing();
                          _focusNode.unfocus();
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButton(
                        value: _dropdownValue,
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text("days"),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text("weeks"),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text("months"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _dropdownValue = value;
                          });
                          prefsFuture.then(
                              (prefs) => prefs.setInt("settings3", value));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
