import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        primaryColor: Color(0xFFDAC68D),
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
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
    final String assetName = 'assets/epassLogo.svg';
    final svg = SvgPicture.asset(
      assetName,
      color: Theme.of(context).primaryColor,
      semanticsLabel: 'Epass Logo',
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          svg,
          RaisedButton(
            onPressed: () {
              print('button clicked --> proceed');
            },
            child: Text("Go"),
          )
        ],
      ),
    );
  }
}
