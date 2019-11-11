import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyLandingPage extends StatelessWidget {
  MyLandingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final logo = SvgPicture.asset(
      'assets/lockAndKey.svg',
      semanticsLabel: 'Epass Logo',
    );

    return Scaffold(
      body: Center(
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
                onPressed: () {
                  print('button clicked --> proceed');
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
    );
  }
}
