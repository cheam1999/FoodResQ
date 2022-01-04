import 'package:flutter/material.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/screen/auth/sign_in.dart';
import 'package:foodresq/utilities/size_config.dart';


class SignInText extends StatelessWidget {
  const SignInText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Have an account?",
          style: TextStyle(fontSize: getProportionateScreenWidth(14)),
        ),
        GestureDetector(
          onTap: () {
            print('Navigate to sign in');
            Navigator.pushNamed(context, SignInScreen.routeName);
          },
          child: Text(
            "Click here to sign in!",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                color: ColourConstant.kHeaderColor),
          ),
        ),
      ],
    );
  }
}