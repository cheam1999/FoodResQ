import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/controller/recipes_controller.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/models/ingredient_model.dart';
import 'package:foodresq/models/recipes_model.dart';
import 'package:foodresq/component/touchable_feedback.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/screen/ingredient_listtile_widget.dart';
import 'package:foodresq/screen/recipes_listing.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:foodresq/controller/recipes_controller.dart';
import 'package:http/http.dart' as http;

import '../main_local.dart';
import '../size_config.dart';
import 'home.dart';
import 'ingredient_listing.dart';

class SelectIngredientPage extends StatefulWidget {
  static String routeName = "/selectIngredient";
  // final bool isMultiSelection;
  const SelectIngredientPage({
    Key? key,
    // this.isMultiSelection = true,
  }) : super(key: key);

  BuildContext get context => context;

  @override
  _SelectIngredientPageState createState() => _SelectIngredientPageState();
}

class _SelectIngredientPageState extends State<SelectIngredientPage> {
  // List<Ingredient> selectedIngredients = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourConstant.kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColourConstant.kHeaderColor,
        title: Text(
          "Recipes",
          style: TextStyle(
            color: ColourConstant.kTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
        return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Container(
              width: double.infinity,
              child: FutureBuilder(
                future: retrieveIngredients(userID),
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
                            // final isSelected = selectedIngredients
                            //     .contains(snapshot.data[index]);
                            return IngredientListTileWidget(
                              ingredients: snapshot.data[index],
                              isSelected: false,
                              onSelectedIngredient: selectIngredient,
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ));
      })),
    );
  }

  void selectIngredient(Ingredient ingredient) {
    // if (widget.isMultiSelection) {
    //   final isSelected = selectedIngredients.contains(ingredient);
    //   setState(() {
    //     isSelected
    //         ? selectedIngredients.remove(ingredient)
    //         : selectedIngredients.add(ingredient);
    //   });
    // } else {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecipeListingPage(
                title: 'Recipe List',
                ingredients: ingredient,
              )),
    );
    // }

    print(ingredient);
  }
}

// Column(
//   children: [
//     FutureBuilder(
//         future: retrieveRecipes(),
//         builder: (context, AsyncSnapshot snapshot) {
//           return TouchableFeedback(
//               onTap: () {
//                 print("Implement Recipe Detail");
//               },
//               child: Card(
//                 clipBehavior: Clip.antiAlias,
//                 elevation: 5.0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(10),
//                     vertical: getProportionateScreenHeight(10),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(
//                             minHeight:
//                                 getProportionateScreenHeight(100),
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10),
//                             child: Column(
//                               mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         snapshot.data,
//                                         maxLines: 2,
//                                         overflow:
//                                             TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           fontSize:
//                                               getProportionateScreenHeight(
//                                                   14),
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ));
//         })
//   ],
// );

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
