import 'package:flutter/material.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/utilities/size_config.dart';

// TODO: Check if the text fit in the small button (dialog)
class DefaultButton extends StatelessWidget {
  DefaultButton({
    Key? key,
    required this.text,
    required this.press,
    bool this.isPrimary = true,
    bool this.isInfinity = true,
  }) : super(key: key);

  final String text;
  final VoidCallback press;
  final bool isPrimary;
  final bool isInfinity;

  final ButtonStyle DefaultButtonStyle = ElevatedButton.styleFrom(
    // onPrimary: kPrimaryColor,
    primary: ColourConstant.kButtonColor,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  final ButtonStyle InActiveDefaultButtonStyle = ElevatedButton.styleFrom(
    // onPrimary: kPrimaryColor,
    primary: ColourConstant.kGreyColor,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(40),
      child: ElevatedButton(
        style: isPrimary ? DefaultButtonStyle : InActiveDefaultButtonStyle,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.bold,
            color: ColourConstant.kTextColor,
          ),
        ),
      ),
    );
  }
}
