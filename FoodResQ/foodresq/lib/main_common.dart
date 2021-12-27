
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:foodresq/routes.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/theme.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FoodResQ',
      theme: theme(),
      initialRoute: HomeScreen.routeName,
      routes: routes,
    );
  }
}
