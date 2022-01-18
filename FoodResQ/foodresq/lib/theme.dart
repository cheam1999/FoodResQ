import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'constants/colour_constant.dart';

MaterialColor swatchify(MaterialColor color, int value) {
  return MaterialColor(color[value].hashCode, <int, Color>{
    50: color[value]!,
    100: color[value]!,
    200: color[value]!,
    300: color[value]!,
    400: color[value]!,
    500: color[value]!,
    600: color[value]!,
    700: color[value]!,
    800: color[value]!,
    900: color[value]!,
  });
}

ThemeData theme() {
  return ThemeData(
    primaryColor: ColourConstant.kBackgroundColor,
    primarySwatch: swatchify(Colors.brown, 600),
    scaffoldBackgroundColor: Color(0xFFFFFDF5),
    // fontFamily: GoogleFonts.montserrat().fontFamily,
    fontFamily: 'Montserrat',
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: ColourConstant.kTextColor),
    gapPadding: 1,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
    errorStyle: TextStyle(color: Colors.red),
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: ColourConstant.kTextColor),
    bodyText2: TextStyle(color: ColourConstant.kTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: true,
    iconTheme: IconThemeData(color: ColourConstant.kTextColor),
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      color: ColourConstant.kTextColor,
      fontSize: 20,
      // fontWeight: FontWeight.bold,
    ),
    // centerTitle: true,
  );
}
