import 'package:flutter/material.dart';

import '../size_config.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    Key? key,
    required this.text,
    this.isBold = true,
    this.heading = 1,
    this.verticalPadding = 2,
    this.horizontalPadding = 0,
    this.textColor = null,
    this.align = TextAlign.start,
  }) : super(key: key);

  final String text;
  final int heading;
  final double verticalPadding;
  final double horizontalPadding;
  final bool isBold;
  final Color? textColor;
  final TextAlign align;

  double returnFontSize({required int heading}) {
    double size = 10;
    switch (heading) {
      case 1:
        size = 25.0;
        break;
      case 2:
        size = 20.0;
        break;
      case 3:
        size = 18.0;
        break;
      case 4:
        size = 16.0;
        break;
      case 5:
        size = 14.0;
        break;
      case 6:
        size = 12.0;
        break;
    }

    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(verticalPadding),
        horizontal: getProportionateScreenHeight(horizontalPadding),
      ),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize:
              getProportionateScreenWidth(returnFontSize(heading: heading)),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: textColor != null ? textColor : null,
        ),
      ),
    );
  }
}
