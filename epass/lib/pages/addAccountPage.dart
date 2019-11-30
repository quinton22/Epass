import 'package:epass/logic/account.dart';
import 'package:epass/logic/authType.dart';
import 'package:epass/logic/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddAccountPage extends StatefulWidget {
  final Storage storage;
  final bool addMode;
  final Account oldAccount;

  AddAccountPage({
    Key key,
    @required this.storage,
    this.addMode = true,
    this.oldAccount,
  }) : super(key: key);

  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  bool isPassIconShowPassButton;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _oldSite;
  String _oldLogin;
  String _site;
  String _login;
  String _password;
  bool _addMode;
  bool _obscurePassword;

  Widget showPasswordButton() => IconButton(
        icon: Icon(
          Icons.remove_red_eye,
          semanticLabel: "Show/Hide",
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        tooltip: "Show/Hide",
      );

  Widget autoGeneratePasswordButton() => IconButton(
        icon: Icon(
          Icons.add_circle,
          semanticLabel: "Autogenerate password",
        ),
        onPressed: () {/*TODO*/},
        tooltip: "Autogenerate password",
      );

  @override
  void initState() {
    if (widget.oldAccount != null) {
      _oldSite = widget.oldAccount.site;
      _oldLogin = widget.oldAccount.login;
    }
    _obscurePassword = true;
    isPassIconShowPassButton = false;
    _addMode = widget.addMode;
    super.initState();
  }

  Future<bool> addAccount() {
    //          _storage.removeAll();
    return widget.storage
        .addAccount(
            Account(
              login: _login,
              site: _site,
            ),
            _password)
        .then((_) {
      print('added');
      return true;
    }).catchError((_) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Failed to add password. Account already exists."),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
        action: SnackBarAction(
          label: "Update Existing",
          onPressed: () {
            setState(() {
              _oldSite = _site;
              _oldLogin = _login;
              _addMode = false;
            });
          },
        ),
      ));
      return false;
    });
  }

  Future<bool> updateAccount() {
    return widget.storage
        .updateAccountWithSiteAndLogin(
      _oldSite,
      _oldLogin,
      newSite: _site,
      newLogin: _login,
      password: _password,
    )
        .then((_) {
      print('added');
      return true;
    }).catchError((e) {
      print(e);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Failed to update password."),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: confirm password
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: _addMode ? "Add Password" : "Update Account",
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            Future<bool> proceed = _addMode ? addAccount() : updateAccount();
            proceed.then((b) => b ? Navigator.of(context).pop(true) : null);
          }
        },
        icon: _addMode ? Icon(Icons.add) : null,
        label: Text(_addMode ? 'Add' : 'Update'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              _addMode ? "Add Password" : "Update Account",
              style: Theme.of(context).textTheme.display1,
            ),
            Theme(
              data: Theme.of(context)
                  .copyWith(accentColor: Theme.of(context).primaryColor),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.url,
                      initialValue: widget.oldAccount != null
                          ? widget.oldAccount.site
                          : null,
                      decoration: InputDecoration(
                        labelText: "Site",
                        hintText: "Ex: Gmail",
                        helperText: "Name of site or the URL",
                      ),
                      validator:
                          // ignore: missing_return
                          (val) {
                        if (val.isEmpty) {
                          return "Please input site.";
                        }
                      },
                      onSaved: (val) => _site = val,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      initialValue: widget.oldAccount != null
                          ? widget.oldAccount.login
                          : null,
                      decoration: InputDecoration(
                        labelText: "Login",
                        hintText: "john.doe@example.com",
                        helperText: "Username/Email",
                      ),
                      validator:
                          // ignore: missing_return
                          (val) {
                        if (val.isEmpty) {
                          return "Please input login.";
                        }
                      },
                      onSaved: (val) => _login = val,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: isPassIconShowPassButton
                            ? showPasswordButton()
                            : autoGeneratePasswordButton(),
                      ),
                      onChanged: (String val) {
                        if (val.isEmpty) {
                          setState(() {
                            isPassIconShowPassButton = false;
                          });
                        } else {
                          setState(() {
                            isPassIconShowPassButton = true;
                          });
                        }
                      },
                      validator:
                          // ignore: missing_return
                          (val) {
                        if (val.isEmpty) {
                          return "Please input password.";
                        }
                      },
                      onSaved: (val) => _password = val,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
