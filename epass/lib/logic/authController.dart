import 'package:epass/logic/authType.dart';
import 'package:epass/pages/loginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthController {
  static final AuthController _instance = AuthController._();
  Map<AuthType, bool> _currentAuth;

  Map<AuthType, bool> get currentAuth => _currentAuth;

  factory AuthController() => _instance;

  AuthController._() {
    _currentAuth = new Map.fromEntries(
        AuthType.values.map((authType) => MapEntry(authType, false)));
  }

  Future<bool> authenticate(List<AuthType> authTypes,
      {BuildContext context}) async {
    bool t = true;
    for (AuthType authType in authTypes) {
      switch (authType) {
        case AuthType.biometric:
          t = t && await _biometric();
          continue;
        case AuthType.password:
          t = t && await _password(context);
          continue;
        case AuthType.text:
          t = t && await _phone(context);
          continue;
        case AuthType.email:
          continue;
        case AuthType.pin:
          continue;
      }
    }
    return t;
  }

  Future<bool> _biometric() async {
    try {
      var localAuth = LocalAuthentication();

//      if (!await localAuth.canCheckBiometrics) {
//        _currentAuth[AuthType.biometric] = false;
//        return;
//      }
//      print(await localAuth.getAvailableBiometrics());
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Please authenticate',
        stickyAuth: true,
      );

      _currentAuth[AuthType.biometric] = didAuthenticate;
      return didAuthenticate;
    } catch (e) {
      print("Exception biometric");
      print(e);
      return false;
    }
  }

  Future<bool> _password(BuildContext context) async {
    // TODO
  }

  Future<bool> _phone(BuildContext context) async {
    // TODO
    bool b = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(
            authType: AuthType.text,
          ),
        )) ??
        false;

    _currentAuth[AuthType.text] = b;
    return b;
  }
}
