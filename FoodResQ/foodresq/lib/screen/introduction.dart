import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodresq/component/default_button.dart';
import 'package:foodresq/component/normal_text.dart';
import 'package:foodresq/screen/auth/sign_in.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/utilities/size_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IntroductionScreen extends HookConsumerWidget {
  static String routeName = "/introduction";
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(15),
            vertical: getProportionateScreenHeight(10),
          ),
          child: Column(
            children: [
              // Text('$authControllerState'),
              Expanded(
                flex: 3,
                child: IntroductionGraphic(),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Spacer(),
                    DefaultButton(
                      text: "Get started!",
                      press: () =>
                          Navigator.pushNamed(context, SignInScreen.routeName),
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IntroductionGraphic extends StatelessWidget {
  const IntroductionGraphic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(
          flex: 1,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              //horizontal: getProportionateScreenWidth(5),
              // vertical: getProportionateScreenHeight(5),
              ),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/graphics/new intro.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(30),
        ),
        NormalText(
          align: TextAlign.center,
          text: "Rescue the Food!",
          isBold: true,
          fontSize: 30,
        ),
        SizedBox(
          height: getProportionateScreenHeight(30),
        ),
        NormalText(
          align: TextAlign.center,
          text:
              "Forget about expired date? \n Thinking hard to finish all ingredients?\n",
          fontSize: 15,
        ),
        NormalText(
          align: TextAlign.center,
          text: "FoodResQ is here to help you!",
          fontSize: 15,
          isBold: true,
        ),
        SizedBox(
          height: getProportionateScreenHeight(40),
        ),
      ],
    );
  }
}
