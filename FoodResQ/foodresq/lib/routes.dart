import 'package:flutter/widgets.dart';
import 'package:foodresq/screen/add_ingredient.dart';
import 'package:foodresq/screen/auth/sign_in.dart';
import 'package:foodresq/screen/auth/sign_up.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/screen/profile.dart';
import 'package:foodresq/screen/start.dart';
import 'package:foodresq/screen/ingredient_listing.dart';
import 'package:foodresq/screen/recipe.dart';


final Map<String, WidgetBuilder> routes = {
  StartScreen.routeName: (context) => StartScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  IngredientListingPage.routeName: (context) => IngredientListingPage(),
  AddIngredientPage.routeName: (context) => AddIngredientPage(title: "Add Ingredient",) ,
  RecipeScreen.routeName: (context) => RecipeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
};
