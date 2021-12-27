

import 'package:flutter/material.dart';
import 'package:foodresq/component/normal_text.dart';
import 'package:foodresq/size_config.dart';

class IntroductionScreen extends StatelessWidget {
  static String routeName = "/introduction";
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          
          child: Column(
            children: [
              Spacer(
                flex: 3,
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
                text:
                    "Just snap all groceries, and we will help to remember them.",
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
                        image: AssetImage('assets/graphics/introduction.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class HookConsumerWidget {
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
          flex: 3,
        ),
        NormalText(
          align: TextAlign.center,
          text: "In Uni With You",
          isBold: true,
          fontSize: 30,
        ),
        Spacer(
          flex: 1,
        ),
        NormalText(
          align: TextAlign.center,
          text:
              "Discover various students offers, scholarships, internships and more. Exclusive for you.",
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
                  image: AssetImage('assets/graphics/introduction.png'),
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
