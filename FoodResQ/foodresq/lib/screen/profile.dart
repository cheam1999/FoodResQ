import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodresq/component/normal_text.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/controller/auth_controller.dart';
import 'package:foodresq/controller/auth_repository.dart';
import 'package:foodresq/controller/sign_in_controller.dart';
import 'package:foodresq/models/user_model.dart';
import 'package:foodresq/utilities/size_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends HookConsumerWidget {
  static String routeName = "/profile";
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
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
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/graphics/background.png"),
              colorFilter: new ColorFilter.mode(
                  Colors.white.withOpacity(0.5), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraint) {
              return Expanded(
                  child: RefreshIndicator(
                displacement: 10,
                onRefresh: () async {
                  await ref
                      .read(authControllerProvider.notifier)
                      .getFoodSavedAndWaste();
                },
                child: Container(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //backgroundBlendMode: BlendMode.overlay,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: getProportionateScreenHeight(40),
                              ),
                              Container(
                                  //padding:,
                                  width: double.infinity,
                                  // height: getProportionateScreenHeight(200),
                                  // decoration: BoxDecoration(color: Colors.white),
                                  constraints: BoxConstraints(
                                    minHeight:
                                        getProportionateScreenHeight(125),
                                  ),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    child: ClipOval(
                                      child: Image.asset(
                                          'assets/graphics/profile.jpg'),
                                    ),
                                  )),
                              SizedBox(
                                  height: getProportionateScreenHeight(20)),
                              NormalText(
                                text: '${authControllerState.name}',
                                fontSize: 25,
                                isBold: true,
                              ),
                              SizedBox(height: getProportionateScreenHeight(5)),
                              NormalText(
                                text: '${authControllerState.email}',
                                fontSize: 15,
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Color(0xFFfc4a1a),
                                        Color(0xFFf7b733)
                                      ],
                                    )
                                    // image: DecorationImage(
                                    //   image:
                                    //       AssetImage("assets/graphics/saved.png"),
                                    //   colorFilter: new ColorFilter.mode(
                                    //       Colors.white.withOpacity(0.3),
                                    //       BlendMode.dstATop),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    ),
                                width: getProportionateScreenWidth(300),
                                height: getProportionateScreenHeight(150),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Ingredients Saved ',
                                          style: TextStyle(
                                              color: ColourConstant.kTextColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('${authControllerState.saved}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 40,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Color(0xFF5B86E5),
                                        Color(0xFF36D1DC)
                                      ],
                                    )),
                                width: getProportionateScreenWidth(300),
                                height: getProportionateScreenHeight(150),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Ingredients Wasted ',
                                          style: TextStyle(
                                            color: ColourConstant.kTextColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('${authControllerState.wasted}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 40,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(40),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
            }),
          ),
        ),
      ),
    );
  }
}
