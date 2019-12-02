//import 'package:epass/logic/authType.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:local_auth/local_auth.dart';
//
//class LoginPage extends StatefulWidget {
//  final AuthType authType;
//
//  const LoginPage({Key key, this.authType}) : super(key: key);
//
//  @override
//  _LoginPageState createState() => _LoginPageState();
//}
//
//class _LoginPageState extends State<LoginPage> {
//  TextEditingController _smsCodeController = TextEditingController();
//  TextEditingController _phoneNumberController = TextEditingController();
//  String verificationId;
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//
//  /// Sends the code to the specified phone number.
//  Future<void> _sendCodeToPhoneNumber() async {
//    final PhoneVerificationCompleted verificationCompleted =
//        (AuthCredential authCredential) {
//      setState(() {
//        print(
//            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $authCredential');
//      });
//    };
//
//    final PhoneVerificationFailed verificationFailed =
//        (AuthException authException) {
//      setState(() {
//        print(
//            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
//      });
//    };
//
//    final PhoneCodeSent codeSent =
//        (String verificationId, [int forceResendingToken]) async {
//      this.verificationId = verificationId;
//      print("code sent to " + _phoneNumberController.text);
//    };
//
//    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//        (String verificationId) {
//      this.verificationId = verificationId;
//      print("time out");
//    };
//
//    await _auth.verifyPhoneNumber(
//        phoneNumber: _phoneNumberController.text,
//        timeout: const Duration(seconds: 5),
//        verificationCompleted: verificationCompleted,
//        verificationFailed: verificationFailed,
//        codeSent: codeSent,
//        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//  }
//
//  /// Sign in using an sms code as input.
//  void _signInWithPhoneNumber(String smsCode) async {
//    final AuthCredential credential = PhoneAuthProvider.getCredential(
//      verificationId: verificationId,
//      smsCode: smsCode,
//    );
//    await _auth
//        .signInWithCredential(credential)
//        .then((AuthResult authResult) async {
//      final FirebaseUser currentUser = await _auth.currentUser();
//      assert(authResult.user.uid == currentUser.uid);
//      print('signed in with phone number successful: user -> $authResult.user');
//      Navigator.of(context).pop(true);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title:
//            new Text('Sign in with ${widget.authType.toString().substring(9)}'),
//      ),
//      body: new Center(
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            new TextField(
//              controller: _phoneNumberController,
//            ),
//            new TextField(
//              controller: _smsCodeController,
//            ),
//            new FlatButton(
//                onPressed: () =>
//                    _signInWithPhoneNumber(_smsCodeController.text),
//                child: const Text("Validate"))
//          ],
//        ),
//      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: () => _sendCodeToPhoneNumber(),
//        tooltip: 'get code',
//        child: new Icon(Icons.send),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
