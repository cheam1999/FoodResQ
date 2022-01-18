import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodresq/component/normal_text.dart';
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
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/screen/recipe_detail.dart';
// import 'package:foodresq/controller/recipes_controller.dart';
import 'package:http/http.dart' as http;

import '../main_local.dart';
import '../size_config.dart';
import 'home.dart';
import 'ingredient_listing.dart';

class RecipeListingPage extends HookConsumerWidget {
  static String routeName = "/recipe";
  final String title;
  // final Ingredient ingredients;
  List<Ingredient> ingredients = [];

  RecipeListingPage({
    Key? key,
    required this.title,
    required this.ingredients,
    // required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColourConstant.kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColourConstant.kHeaderColor,
        title: Text(
          title,
          style: TextStyle(
            color: ColourConstant.kTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
        String ingredientList = "${ingredients[0].ingredientName}";
        for (int i = 1; i < ingredients.length; i++) {
          ingredientList =
              '${ingredientList}, ${ingredients[i].ingredientName}';
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: buildListTile(
                    title: "No Ingredient", ingredientList: ingredientList),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Container(
                  width: double.infinity,
                  child: FutureBuilder(
                    future: retrieveRecipes(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            "",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: RefreshIndicator(
                            onRefresh: () async {},
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                // print(snapshot.data[index].recipeIngredients);
                                // print(ingredientList);
                                return snapshot.data[index].recipeIngredients
                                        .contains(ingredientList)
                                    ? Column(
                                        children: [
                                          TouchableFeedback(
                                            onTap: () {
                                              print("Testing");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeDetailPage(
                                                          title:
                                                              '${snapshot.data[index].recipeName}',
                                                          recipe: snapshot
                                                              .data[index],
                                                        )),
                                              );
                                            },
                                            child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              elevation: 5.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(
                                                          15),
                                                  vertical:
                                                      getProportionateScreenHeight(
                                                          10),
                                                ),
                                                // height: getProportionateScreenHeight(125),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      width:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      child: Opacity(
                                                        opacity: 1,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            '${snapshot.data[index].recipeImage}',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                          minHeight:
                                                              getProportionateScreenHeight(
                                                                  100),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Malaysian Food",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: getProportionateScreenHeight(
                                                                              12),
                                                                          color:
                                                                              ColourConstant.kHeaderColor),
                                                                    ),
                                                                    Text(
                                                                      "${snapshot.data[index].recipeName}",
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            getProportionateScreenHeight(15),
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        physics:
                                                                            ClampingScrollPhysics(),
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          // mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            if (snapshot.data[index].recipeLevel ==
                                                                                "Beginner")
                                                                              RecipeCardTag(
                                                                                tag: "Beginner",
                                                                                color: Colors.green,
                                                                              ),
                                                                            if (snapshot.data[index].recipeLevel ==
                                                                                "Intermediate")
                                                                              RecipeCardTag(
                                                                                tag: "Intermediate",
                                                                                color: Colors.orange,
                                                                              ),

                                                                            if (snapshot.data[index].recipeLevel ==
                                                                                "Masterchef")
                                                                              RecipeCardTag(
                                                                                tag: "Masterchef",
                                                                                color: Colors.red,
                                                                              ),

                                                                            // RecipeCardTag(
                                                                            //   tag: "Popular",
                                                                            //   color: UgekColors.kSecondaryColor,
                                                                            // ),
                                                                            // RecipeCardTag(
                                                                            //   tag: "Halal",
                                                                            //   color: UgekColors.kSecondaryColor,
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // NormalText(
                                                                    //   fontSize: 11,
                                                                    //   text:
                                                                    //       "${snapshot.data[index].recipeIngredients}",
                                                                    //   textColor:
                                                                    //       ColourConstant
                                                                    //           .kGreyColor,
                                                                    //   verticalPadding:
                                                                    //       1,
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Expanded(
                                                    //   flex: 1,
                                                    //   child: Center(
                                                    //     child: Container(
                                                    //       child: IconButton(
                                                    //         icon: post.isSaved
                                                    //             ? UgekIcons.liked
                                                    //             : UgekIcons.unliked,
                                                    //         onPressed: likeFunction,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      })),
    );
  }

  // Widget buildSingleIngredient(BuildContext context) {
  //   final onTap = () {
  //     // final ingredient = await Navigator.popAndPushNamed(
  //     //   context,
  //     //   SelectIngredientPage.routeName,
  //     // );
  //     // // if (ingredient == null) return;
  //     // // setState(() => this.ingredient = ingredient);
  //     // print(ingredient);
  //   };

  //   return buildListTile(title: "No Ingredient", onTap: () {});
  // }

  Widget buildListTile(
      {required String title, required String ingredientList}) {
    return ListTile(
      // onTap: onTap,
      title: Text(
        // "${ingredients[0].ingredientName}",
        "${ingredientList}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}

@override
Future<List<Recipes>> retrieveRecipes() async {
  final String apiRoute = 'get_recipe';
  var url = Uri.parse(env!.baseUrl + apiRoute);
  print("Requesting to $url");

  var response = await http.get(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var responseBody = response.body;

  if (response.statusCode == 200) {
    final results = List<Map<String, dynamic>>.from(json.decode(responseBody));

    List<Recipes> items =
        results.map((item) => Recipes.fromMap(item)).toList(growable: false);

    return items;
  } else {
    throw CustomException(message: 'Failed to retrieve recipe!');
  }
}

class RecipeCardTag extends StatelessWidget {
  const RecipeCardTag({Key? key, required this.tag, required this.color})
      : super(key: key);

  final String tag;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Container(
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            tag,
            style: TextStyle(
                fontSize: getProportionateScreenHeight(9), color: color),
          ),
        ),
      ),
    );
  }
}
