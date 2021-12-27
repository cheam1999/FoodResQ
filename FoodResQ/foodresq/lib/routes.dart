import 'package:flutter/widgets.dart';
import 'package:foodresq/screen/add_ingredient.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/screen/profile.dart';
import 'package:foodresq/screen/recipe.dart';
import 'package:foodresq/screen/ingredient_listing.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  IngredientListingPage.routeName: (context) => IngredientListingPage(),
  AddIngredientPage.routeName: (context) => AddIngredientPage(title: "Add Ingredient",) ,
  RecipeScreen.routeName: (context) => RecipeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
