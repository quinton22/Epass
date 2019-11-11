import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colorMap = {
      'darkGold': Color(0xFFDCAA46),
      'lightGold': Color(0xFFDAC68D),
      'mediumGold': Color(0xFFDAB86A),
    };
    return MaterialApp(
      title: 'Epass',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: colorMap['mediumGold'],
        primaryColorLight: colorMap['lightGold'],
        primaryColorDark: colorMap['darkGold'],
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        accentColor: Color(0xFF444444),
      ),
      home: MyLandingPage(title: 'Epass'),
    );
  }
}

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          logo,
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
    );
  }
}
