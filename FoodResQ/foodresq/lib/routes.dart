import 'package:flutter/widgets.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/screen/ingredient.dart';
import 'package:foodresq/screen/introduction.dart';
import 'package:foodresq/screen/profile.dart';
import 'package:foodresq/screen/recipe.dart';
import 'package:foodresq/screen/start.dart';

final Map<String, WidgetBuilder> routes = {
  StartScreen.routeName: (context) => StartScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  IngredientScreen.routeName: (context) => IngredientScreen(),
  RecipeScreen.routeName: (context) => RecipeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  IntroductionScreen.routeName: (context) => IntroductionScreen(),
};
