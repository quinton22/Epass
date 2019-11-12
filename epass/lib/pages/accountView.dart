import 'package:epass/logic/account.dart';
import 'package:epass/logic/storage.dart';
import 'package:epass/pages/addAccountPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountView extends StatefulWidget {
  final Account account;
  final Storage storage;
  final reload;
  AccountView({this.account, this.storage, this.reload});

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

  void _updateAccount() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddAccountPage(
        storage: widget.storage,
        addMode: false,
        oldAccount: widget.account,
      ),
    ));
  }

  void _deleteAccount() async {
    await widget.storage.removeAccount(widget.account.id);
    widget.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: InkWell(
              onLongPress: _togglePassword,
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
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text('Show Password'),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('Update'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (val) {
                  switch (val) {
                    case 0:
                      _togglePassword();
                      break;
                    case 1:
                      _updateAccount();
                      break;
                    case 2:
                      _deleteAccount();
                      break;
                  }
                },
              ),
            ),
          ),
        ],
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
