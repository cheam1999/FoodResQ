import 'package:flutter/material.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/utilities/size_config.dart';

class NormalText extends StatelessWidget {
  const NormalText(
      {Key? key,
      required this.text,
      this.isBold = false,
      this.isUnderlined = false,
      this.fontSize = 15,
      this.verticalPadding = 2,
      this.textColor = null,
      this.overflow = null,
      this.align = TextAlign.start,
      this.maxline = null})
      : super(key: key);

  final String text;
  final double fontSize;
  final double verticalPadding;
  final bool isBold;
  final bool isUnderlined;
  final Color? textColor;
  final TextAlign align;
  final int? maxline;

  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(verticalPadding)),
      child: Text(
        text,
        textAlign: align,
        maxLines: maxline,
        overflow: overflow,
        style: TextStyle(
          fontSize: getProportionateScreenWidth(fontSize),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: textColor != null ? textColor : ColourConstant.kTextColor,
          decoration: isUnderlined ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}
