import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IngredientScreen extends HookConsumerWidget {
  static String routeName = "/ingredient";
  const IngredientScreen({
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
          "My Ingredients",
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
            children: [
              Text(
                "Ingredient Page",
                style: TextStyle(fontSize: 50),
              ),
            ],
          );
        }),
      ),
    );
  }
}
