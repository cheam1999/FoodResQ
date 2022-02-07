import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:foodresq/routes.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/screen/introduction.dart';
import 'package:foodresq/screen/recipes_listing.dart';
import 'package:foodresq/screen/select_ingredient.dart';
import 'package:foodresq/screen/start.dart';
import 'package:foodresq/theme.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: GetMaterialApp(
        title: 'FoodResQ',
        theme: theme(),
        initialRoute: StartScreen.routeName,
        routes: routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


