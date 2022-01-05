import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

// TODO: Fix this MediaQuery delay in release
// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double? screenHeight = SizeConfig.screenHeight;

  if (screenHeight != null)
    return (inputHeight / 812.0) * screenHeight;
  else
    return inputHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double? screenWidth = SizeConfig.screenWidth;

  if (screenWidth != null)
    return (inputWidth / 375.0) * screenWidth;
  else
    return inputWidth;
}
