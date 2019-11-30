import 'package:epass/logic/authType.dart';
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

  Future<void> authenticate(List<AuthType> authTypes) async {
    for (AuthType authType in authTypes) {
      switch (authType) {
        case AuthType.biometric:
          await _biometric();
          continue;
        case AuthType.password:
          continue;
        case AuthType.text:
          continue;
        case AuthType.email:
          continue;
        case AuthType.pin:
          continue;
      }
    }
  }

  Future<void> _biometric() async {
    try {
      var localAuth = LocalAuthentication();

//      if (!await localAuth.canCheckBiometrics) {
//        _currentAuth[AuthType.biometric] = false;
//        return;
//      }
//      print(await localAuth.getAvailableBiometrics());
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Please authenticate to add new password',
      );

      _currentAuth[AuthType.biometric] = didAuthenticate;
    } catch (e) {
      print("Exception biometric");
      print(e);
    }
  }
}
