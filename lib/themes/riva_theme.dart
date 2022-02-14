import 'package:flutter/material.dart';

class RivaTheme {
  static TextTheme whiteText = const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline1: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline2: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline4: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline5: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static TextTheme blueText = const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.blue,
    ),
    headline1: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.blue,
    ),
    headline2: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: Colors.blue,
    ),
    headline3: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.blue,
    ),
    headline4: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: Colors.blue,
    ),
    headline5: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.blue,
    ),
    headline6: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.blue,
    ),
  );

  static TextTheme blackText = const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headline1: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline2: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline4: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline5: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headline6: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  );

  static TextTheme redText = const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.red,
    ),
    headline1: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.red,
    ),
    headline2: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: Colors.red,
    ),
    headline3: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.red,
    ),
    headline4: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: Colors.red,
    ),
    headline5: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.red,
    ),
    headline6: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.red,
    ),
  );

  static TextTheme indigoText = const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.indigo,
    ),
    headline1: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.indigo,
    ),
    headline2: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: Colors.indigo,
    ),
    headline3: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.indigo,
    ),
    headline4: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: Colors.indigo,
    ),
    headline5: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.indigo,
    ),
    headline6: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.indigo,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Colors.indigo)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      fontFamily: "SFProDisplay",
      textTheme: blackText,
    );
  }
}
