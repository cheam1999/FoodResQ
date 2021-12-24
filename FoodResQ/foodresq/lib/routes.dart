

import 'package:flutter/widgets.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/screen/ingredient.dart';
import 'package:foodresq/screen/profile.dart';
import 'package:foodresq/screen/recipe.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  IngredientScreen.routeName: (context) => IngredientScreen(),
  RecipeScreen.routeName: (context) => RecipeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
