import 'package:epass/logic/account.dart';
import 'package:epass/logic/storage.dart';
import 'package:epass/pages/accountView.dart';
import 'package:flutter/material.dart';

class PasswordListPage extends StatefulWidget {
  @override
  _PasswordListPageState createState() => _PasswordListPageState();
}

class _PasswordListPageState extends State<PasswordListPage> {
  final Storage _storage = Storage();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _storage.close();
    super.dispose();
  }

  void addAccount() {
    //          _storage.removeAll();
    _storage
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
      key: key,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addAccount();
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder(
            // TODO: make stream
            future: _storage.getAllAccounts(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child:
                      CircularProgressIndicator(), // TODO: make better loading animation
                );

              if (snapshot.data.length == 0)
                return Center(child: Text("Click the '+' to add a password."));

              return Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ListView(
                    children: snapshot.data
                        .map((account) => AccountView(account: account))
                        .toList(),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
