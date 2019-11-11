import 'package:epass/pages/landingPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colorMap = {
      'darkGold': Color(0xFFDCAA46),
      'lightGold': Color(0xFFDAC68D),
      'mediumGold': Color(0xFFDAB86A),
      'darkGrey': Color(0xFF444444),
      'lightGrey': Color(0xFF777777),
    };
    return MaterialApp(
      title: 'Epass',
      theme: ThemeData(
        primaryColor: colorMap['mediumGold'],
        primaryColorLight: colorMap['lightGold'],
        primaryColorDark: colorMap['darkGold'],
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        accentColor: colorMap['darkGrey'],
        dividerTheme: DividerThemeData(
          color: colorMap['lightGrey'],
        ),
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
          body2: TextStyle(color: Colors.white),
        ),
      ),
      home: MyLandingPage(title: 'Epass'),
    );
  }
}
