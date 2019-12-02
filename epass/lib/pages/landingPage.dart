import 'package:epass/logic/authController.dart';
import 'package:epass/logic/authType.dart';
import 'package:epass/logic/storage.dart';
import 'package:epass/pages/passwordListPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyLandingPage extends StatelessWidget {
  MyLandingPage({Key key, this.title}) : super(key: key);
  final AuthController authController = AuthController();
  final Storage storage = Storage();

  final String title;

  @override
  Widget build(BuildContext context) {
    final logo = SvgPicture.asset(
      'assets/lockAndKey.svg',
      semanticsLabel: 'Epass Logo',
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 0.9,
                child: logo, // TODO: animate logo
              ),
              Spacer(),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: RaisedButton(
                  onPressed: () async {
                    if (await authController.authenticate([AuthType.biometric]))
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PasswordListPage(
                              authController: authController,
                              storage: storage)));
                  },
                  child: Container(
                    child: Text(
                      "Go",
                      semanticsLabel: "Go",
                      textScaleFactor: 1.25,
                    ),
                    height: 50.0,
                    alignment: Alignment.center,
                  ),
                  shape: StadiumBorder(),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
