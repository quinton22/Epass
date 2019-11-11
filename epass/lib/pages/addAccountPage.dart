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
  bool isPassIconShowPassButton;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _site;
  String _login;
  String _password;

  Widget showPasswordButton = IconButton(
    icon: Icon(
      Icons.remove_red_eye,
      semanticLabel: "Show/Hide",
    ),
    onPressed: () {/*TODO*/},
    tooltip: "Show/Hide",
  );

  Widget autoGeneratePasswordButton = IconButton(
    icon: Icon(
      Icons.add_circle,
      semanticLabel: "Autogenerate password",
    ),
    onPressed: () {/*TODO*/},
    tooltip: "Autogenerate password",
  );

  @override
  void initState() {
    isPassIconShowPassButton = false;
    super.initState();
  }

  void addAccount() {
    //          _storage.removeAll();
    widget.storage
        .addAccount(
            Account(
              login: _login,
              authTypes: [], // TODO
              site: _site,
            ),
            _password)
        .then((_) => print('added'))
        .catchError((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
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
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Add Password",
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            addAccount();
            Navigator.of(context).pop(true);
          }
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              "Add Password",
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
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: isPassIconShowPassButton
                            ? showPasswordButton
                            : autoGeneratePasswordButton,
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
