import 'package:epass/logic/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountView extends StatefulWidget {
  final Account account;
  AccountView({this.account});

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  bool _showPassword;
  String _password;
  final String _hiddenPasswordChar = '\u25CF'; // \u25cf \u2022

  @override
  void initState() {
    _showPassword = false;
    super.initState();
  }

  void _togglePassword() async {
    if (_password != null) {
      // show/hide password
      setState(() {
        _showPassword = !_showPassword;
      });
    } else {
      // retrieve and show password
      var storage = FlutterSecureStorage();
      _password = await storage.read(key: "pw${widget.account.id}");
      _showPassword = true;
    }
  }

  String _getHiddenPassword() {
    String str = '';
    for (int i = 0; i < 10; ++i) {
      str += _hiddenPasswordChar;
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _togglePassword,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(widget.account.site),
            Divider(),
            Text('Login: ${widget.account.login}'),
            Text(
              'Password: ${_showPassword ? (_password ?? 'No password') : _getHiddenPassword()}',
            ),
          ],
        ),
      ),
    );
  }
}
