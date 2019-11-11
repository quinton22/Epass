import 'package:epass/logic/account.dart';
import 'package:epass/logic/storage.dart';
import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget {
  final Storage storage;
  final bool addMode;
  AddAccountPage({Key key, @required this.storage, this.addMode = true})
      : super(key: key);

  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _siteController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void addAccount() {
    //          _storage.removeAll();
    widget.storage
        .addAccount(Account(
      login: 'user',
      authTypes: [],
      site: 'site',
    ))
        .then((_) {
      print('added');
    }).catchError((_) {
      key.currentState.showSnackBar(SnackBar(
        content: Text("Failed to add password. Account already exists."),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "Update",
          onPressed: () {/*TODO*/},
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addAccount();
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Text("Add Password"),
            Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _siteController,
                  ),
                  TextFormField(
                    controller: _loginController,
                  ),
                  TextFormField(
                    controller: _passwordController,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
