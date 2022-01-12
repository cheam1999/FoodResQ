import 'package:flutter/material.dart';
import 'package:foodresq/component/normal_text.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/screen/auth/sign_up.dart';


class NoAccountText extends StatelessWidget {
  const NoAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: NormalText(
              text: "No account? ",
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                print('Navigate to sign up');
                Navigator.pushNamed(context, SignUpScreen.routeName);
              },
              child: NormalText(
                text: "Sign up now!",
                textColor: ColourConstant.kHeaderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}