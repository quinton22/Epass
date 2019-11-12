import 'package:epass/logic/account.dart';
import 'package:epass/logic/storage.dart';
import 'package:epass/pages/accountView.dart';
import 'package:epass/pages/addAccountPage.dart';
import 'package:flutter/material.dart';

class PasswordListPage extends StatefulWidget {
  @override
  _PasswordListPageState createState() => _PasswordListPageState();
}

class _PasswordListPageState extends State<PasswordListPage> {
  final Storage _storage = Storage();
  Future<List<Account>> _accountFuture;

  @override
  void initState() {
    _accountFuture = _storage.getAllAccounts();
    super.initState();
  }

  @override
  void dispose() {
    _storage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => AddAccountPage(
              storage: _storage,
            ),
          ))
              .then((b) {
            print(b);
            if (b)
              setState(() {
                _accountFuture = _storage.getAllAccounts();
              });
          });
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder(
            // TODO: make stream
            future: _accountFuture,
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
                    children: snapshot.data.map((account) {
                      var a = AccountView(account: account);
                      a.createState();
                      return a;
                    }).toList(),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
