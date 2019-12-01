import 'package:epass/logic/account.dart';
import 'package:epass/logic/authController.dart';
import 'package:epass/logic/storage.dart';
import 'package:epass/pages/accountView.dart';
import 'package:epass/pages/addAccountPage.dart';
import 'package:epass/pages/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:epass/secret.dart';
import 'dart:convert' as convert;

class PasswordListPage extends StatefulWidget {
  final AuthController authController;
  final Storage storage;

  const PasswordListPage({Key key, this.authController, this.storage})
      : super(key: key);

  @override
  _PasswordListPageState createState() => _PasswordListPageState();
}

class _PasswordListPageState extends State<PasswordListPage> {
  Future<List<Account>> _accountFuture;
  List<Map<String, dynamic>> _unknownVuln = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> _accountVuln = List<Map<String, dynamic>>();

  @override
  void initState() {
    _accountFuture = widget.storage.getAllAccounts();
    fetchDataFromAPI();
    super.initState();
  }

  @override
  void dispose() {
    widget.storage.close();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _accountVuln = List();
      _accountFuture = widget.storage.accounts;
      fetchDataFromAPI();
    });
  }

  void fetchDataFromAPI() async {
    final acc = await _accountFuture;

    final String service = "breachedaccount";

    final accSet = acc.map((Account a) => a.login).toSet();
    accSet.removeWhere((String login) =>
        !login.contains('@') && !login.contains(r'/\.[a-z]{3}|[a-z]{2}$/'));

    List<Map<String, dynamic>> checkVuln = List<Map<String, dynamic>>();

    for (String a in accSet) {
      final String parameter = Uri.encodeComponent(a); // TODO
      final String uri =
          "https://haveibeenpwned.com/api/v3/$service/$parameter?truncateResponse=false";

      http.Response response = await http.get(uri, headers: {
        'hibp-api-key': HIBP_API_KEY,
        'user-agent': 'Epass',
      });

      Map<String, dynamic> vuln = Map<String, dynamic>();

      vuln['login'] = a;
      vuln['vulnList'] = convert.jsonDecode(response.body);

      checkVuln.add(vuln);
    }

    for (Account a in acc) {
      var vv;
      for (var vuln in checkVuln) {
        // login is not the same
        if (a.login != vuln['login']) continue;

        for (var v in vuln['vulnList']) {
          // changed password after the vuln occurred
          if (a.lastChanged >
              DateTime.parse(v['BreachDate']).millisecondsSinceEpoch) {
            _unknownVuln.add(v);
            continue;
          }

          // TODO: change to making the user check off when they have changed their password

          if (a.site.toLowerCase().contains(v['Title'].toLowerCase()) ||
              a.site.toLowerCase().contains(v['Domain'].toLowerCase()) ||
              v['Title'].toLowerCase().contains(a.site.toLowerCase()) ||
              v['Domain'].toLowerCase().contains(a.site.toLowerCase())) {
            vv = v;
            break;
          } else {
            _unknownVuln.add(v);
          }
        }
      }
      _accountVuln.add(vv);
    }

    setState(() {});

//    print(_accountVuln);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage())); // TODO
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => AddAccountPage(
              storage: widget.storage,
              authController: widget.authController,
            ),
          ))
              .then((b) {
            if (b) {
              setState(() {
                _accountFuture = widget.storage.accounts;
              });

              _accountVuln = List();
              fetchDataFromAPI();
              print('here');
            }
            print('here2');
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
                    children: snapshot.data
                        .asMap()
                        .map((i, account) {
                          var a = AccountView(
                              key: UniqueKey(),
                              vuln: _accountVuln.length > i
                                  ? _accountVuln[i]
                                  : null,
                              account: account,
                              storage: widget.storage,
                              reload: _reload,
                              authController: widget.authController);
                          return MapEntry(i, a);
                        })
                        .values
                        .toList(),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
