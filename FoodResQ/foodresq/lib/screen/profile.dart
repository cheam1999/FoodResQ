import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodresq/component/normal_text.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/utilities/size_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';

class ProfileScreen extends HookConsumerWidget {
  static String routeName = "/profile";
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //https://stackoverflow.com/questions/56326005/how-to-use-expanded-in-singlechildscrollview
    return Scaffold(
      //drawer: CustomDrawer(),
      backgroundColor: ColourConstant.kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColourConstant.kHeaderColor,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: ColourConstant.kTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              Container(
                  //padding:,
                  width: double.infinity,
                  // height: getProportionateScreenHeight(200),
                  // decoration: BoxDecoration(color: Colors.white),
                  constraints: BoxConstraints(
                    minHeight: getProportionateScreenHeight(125),
                  ),
                  child: CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: Image.asset('assets/graphics/profile.jpg'),
                    ),
                  )),
              SizedBox(height: getProportionateScreenHeight(20)),
              NormalText(
                text: 'John Doe',
                fontSize: 25,
                isBold: true,
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              NormalText(
                text: 'test@test.com',
                fontSize: 15,
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              Container(
                color: Colors.white,
                width: getProportionateScreenWidth(300),
                height: getProportionateScreenHeight(150),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: const <TextSpan>[
                              TextSpan(
                                text: 'You have saved ',
                                style: TextStyle(
                                  color: ColourConstant.kTextColor2,
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                  text: '\n     20 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColourConstant.kButtonColor,
                                    fontSize: 40,
                                  )),
                              TextSpan(
                                  text: '\n    ingredients',
                                  style: TextStyle(
                                    color: ColourConstant.kTextColor2,
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              Container(
                color: Colors.white,
                width: getProportionateScreenWidth(300),
                height: getProportionateScreenHeight(150),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: const <TextSpan>[
                              TextSpan(
                                text: 'You have wasted ',
                                style: TextStyle(
                                  color: ColourConstant.kTextColor2,
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                  text: '\n     20 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColourConstant.kButtonColor,
                                    fontSize: 40,
                                  )),
                              TextSpan(
                                  text: '\n    ingredients',
                                  style: TextStyle(
                                    color: ColourConstant.kTextColor2,
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
