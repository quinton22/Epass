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

  @override
  void initState() {
    _showPassword = false;
    super.initState();
  }

  void _togglePassword() async {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        print('delete'); // TODO
      },
      onTap: _togglePassword,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.account.site,
              style: Theme.of(context).textTheme.title,
            ),
            Text('${widget.account.login}'),
            PasswordView(
              showPassword: _showPassword,
              id: widget.account.id,
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordView extends StatelessWidget {
  final bool showPassword;
  final int id;
  final String _hiddenPasswordChar = '\u25CF'; // \u25cf \u2022

  const PasswordView({Key key, this.showPassword, this.id}) : super(key: key);

  String _getHiddenPassword() {
    String str = '';
    for (int i = 0; i < 10; ++i) {
      str += _hiddenPasswordChar;
    }
    return str;
  }

  Future<String> _getPassword() async {
    var storage = FlutterSecureStorage();
    String password = await storage.read(key: "pw$id");
    return password;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: _getHiddenPassword(),
      future: _getPassword(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Text(
            '${showPassword ? (snapshot.data ?? '') : _getHiddenPassword()}',
          );
        return Text('');
      },
    );
  }
}
