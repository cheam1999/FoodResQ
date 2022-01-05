import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/controller/recipes_controller.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/models/ingredient_model.dart';
import 'package:foodresq/models/recipes_model.dart';
import 'package:foodresq/component/touchable_feedback.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/screen/ingredient_listtile_widget.dart';
import 'package:foodresq/screen/select_ingredient.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:foodresq/controller/recipes_controller.dart';
import 'package:http/http.dart' as http;

import '../main_local.dart';
import '../size_config.dart';
import 'home.dart';
import 'ingredient_listing.dart';

class RecipeListingPage extends HookConsumerWidget {
  static String routeName = "/recipe";
  final String title;
  final Ingredient ingredients;
  const RecipeListingPage({
    Key? key,
    required this.title,
    required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColourConstant.kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColourConstant.kHeaderColor,
        title: Text(
          "Recipes List",
          style: TextStyle(
            color: ColourConstant.kTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: buildSingleIngredient(context),
              ),
            )
          ],
        );
      })),
    );
  }

  Widget buildSingleIngredient(BuildContext context) {
    final onTap = () {
      // final ingredient = await Navigator.popAndPushNamed(
      //   context,
      //   SelectIngredientPage.routeName,
      // );
      // // if (ingredient == null) return;
      // // setState(() => this.ingredient = ingredient);
      // print(ingredient);
    };

    return buildListTile(title: "No Ingredient", onTap: () {});
  }

  Widget buildListTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        "${ingredients.ingredientName}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}
