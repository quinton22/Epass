import 'package:epass/logic/account.dart';
import 'package:epass/logic/authController.dart';
import 'package:epass/logic/storage.dart';
import 'package:epass/pages/accountView.dart';
import 'package:epass/pages/addAccountPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:epass/secret.dart';
import 'dart:convert' as convert;

class PasswordListPage extends StatefulWidget {
  final AuthController authController;

  const PasswordListPage({Key key, this.authController}) : super(key: key);

  @override
  _PasswordListPageState createState() => _PasswordListPageState();
}

class _PasswordListPageState extends State<PasswordListPage> {
  final Storage _storage = Storage();
  Future<List<Account>> _accountFuture;

  http.Response _response;

  @override
  void initState() {
    fetchDataFromAPI();
    _accountFuture = _storage.getAllAccounts();
    super.initState();
  }

  @override
  void dispose() {
    _storage.close();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _accountFuture = _storage.accounts;
    });
  }

  void fetchDataFromAPI() async {
    if (_response != null && _response.statusCode == 200) return;

    final String service = "breachedaccount";
    final String parameter =
        Uri.encodeComponent("john.doe@example.com"); // TODO
    final String uri =
        "https://haveibeenpwned.com/api/v3/$service/$parameter?truncateResponse=false";

    print(uri);
    _response = await http.get(uri, headers: {
      'hibp-api-key': HIBP_API_KEY,
      'user-agent': 'Epass',
    });

    print(_response.statusCode);
    print(convert.jsonDecode(_response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => print('go to settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => AddAccountPage(
              storage: _storage,
              authController: widget.authController,
            ),
          ))
              .then((b) {
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
                      var a = AccountView(
                          account: account,
                          storage: _storage,
                          reload: _reload,
                          authController: widget.authController);
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
