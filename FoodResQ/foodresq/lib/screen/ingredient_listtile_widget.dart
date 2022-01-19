import 'package:flutter/material.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/main_local.dart';
import 'package:foodresq/models/ingredient_model.dart';
import 'package:foodresq/screen/ingredient_listing.dart';
import 'package:foodresq/screen/select_ingredient.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:foodresq/screen/recipes_listing.dart';
import 'home.dart';

class IngredientListTileWidget extends StatelessWidget {
  final Ingredient ingredients;
  final bool isSelected;
  final ValueChanged<Ingredient> onSelectedIngredient;

  IngredientListTileWidget({
    Key? key,
    required this.ingredients,
    required this.isSelected,
    required this.onSelectedIngredient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => onSelectedIngredient(ingredients),
        title: Container(
          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              border: isSelected
                  ? Border.all(
                      color: Colors.black,
                    )
                  : Border.all(
                      color: Colors.grey,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: calculateDaysLeft(
                                            date: ingredients.expiryDate!) >
                                        3
                                    ? Colors.green
                                    : calculateDaysLeft(
                                                date:
                                                    ingredients.expiryDate!) >=
                                            0
                                        ? Colors.orange
                                        : Colors.red,
                                width: isSelected ? 3 : 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: calculateDaysLeft(
                                          date: ingredients.expiryDate!) >
                                      3
                                  ? Text(
                                      "Good",
                                      style: isSelected
                                          ? TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(fontSize: 12),
                                    )
                                  : calculateDaysLeft(
                                              date: ingredients.expiryDate!) >=
                                          0
                                      ? Text(
                                          "Expire \n Soon",
                                          style: isSelected
                                              ? TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                )
                                              : TextStyle(fontSize: 12),
                                        )
                                      : Text(
                                          "Expired",
                                          style: isSelected
                                              ? TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                )
                                              : TextStyle(fontSize: 12),
                                        ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ingredients.ingredientName}',
                              overflow: TextOverflow.ellipsis,
                              style: isSelected
                                  ? TextStyle(
                                      fontSize: 16,
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : TextStyle(
                                      fontSize: 16.0,
                                    ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            calculateDaysLeft(date: ingredients.expiryDate!) >=
                                    0
                                ? Text(
                                    "${calculateDaysLeft(date: ingredients.expiryDate!)} days left",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: calculateDaysLeft(
                                                  date:
                                                      ingredients.expiryDate!) >
                                              3
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  )
                                : Text(
                                    "Expired ${-calculateDaysLeft(date: ingredients.expiryDate!)} days ago",
                                    overflow: TextOverflow.ellipsis,
                                    style: isSelected
                                        ? TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          )
                                        : TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.red,
                                          ),
                                  ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Expires on: ${reformatDate(date: ingredients.expiryDate!)}",
                              style: isSelected
                                  ? TextStyle(
                                      fontSize: 10,
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : TextStyle(
                                      fontSize: 10.0,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: isSelected
                            ? IconButton(
                                icon: Icon(Icons.check_box),
                                onPressed: () {},
                              )
                            : IconButton(
                                icon: Icon(Icons.check_box_outline_blank),
                                onPressed: () {
                                  onSelectedIngredient(ingredients);
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // void selectIngredients(Ingredient ingredient) {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //       builder: (context) => RecipeListingPage(title: 'Recipe List')),
  //   // );
  // }
}
