import 'package:flutter/material.dart';
import 'package:foodresq/routes.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/theme.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodResQ',
      theme: theme(),
      initialRoute: HomeScreen.routeName,
      routes: routes,
    );
  }
}
