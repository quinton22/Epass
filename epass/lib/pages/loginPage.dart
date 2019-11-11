import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAuthenticated = false;

  void auth() async {
    final LocalAuthentication lAuth = LocalAuthentication();
    if (await lAuth.canCheckBiometrics) {
      isAuthenticated = await lAuth.authenticateWithBiometrics(
          localizedReason: 'View Passwords');
    } else {
      // MFA
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
