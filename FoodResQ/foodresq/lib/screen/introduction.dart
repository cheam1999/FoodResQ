import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodresq/component/default_button.dart';
import 'package:foodresq/component/normal_text.dart';
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
                      text: "Get started",
                      press: () => Navigator.pushNamedAndRemoveUntil(context,
                          HomeScreen.routeName, ModalRoute.withName('/')),
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
          flex: 2,
        ),
        NormalText(
          align: TextAlign.center,
          text: "Remember All Food",
          isBold: true,
          fontSize: 30,
        ),
        Spacer(
          flex: 1,
        ),
        NormalText(
          align: TextAlign.center,
          text: "Just snap all groceries, and we will help to remember them.",
          fontSize: 15,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(10),
          ),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/graphics/intro1_remember.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
