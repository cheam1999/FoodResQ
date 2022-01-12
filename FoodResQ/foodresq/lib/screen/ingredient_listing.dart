import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/constants/dialog.dart';
import 'package:foodresq/controller/auth_controller.dart';
import 'package:foodresq/controller/auth_repository.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/main_local.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/models/ingredient_model.dart';
import 'package:foodresq/models/user_model.dart';
import 'package:foodresq/screen/add_ingredient.dart';
import 'package:foodresq/screen/auth/sign_in.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/screen/ingredient_listing_repository.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final ingredientListingRepositoryProvider =
    Provider<IngredientRepository>((ref) => IngredientRepository(ref.read));

class IngredientListingPage extends HookConsumerWidget {
  static String routeName = "/ingredient";
  const IngredientListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Future<List<Ingredient>> futureIngredient = ref.read(ingredientListingRepositoryProvider).retrieveIngredients();
    return Scaffold(
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
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: ColourConstant.kGreyColor,
            onPressed: () {
              showLogoutDialog(
                context: context,
                confirmEvent: () {
                  ref.read(authControllerProvider.notifier).signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.routeName,
                    ModalRoute.withName('/'),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraint) {
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
                future: ref
                    .read(ingredientListingRepositoryProvider)
                    .retrieveIngredients(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          color: ColourConstant.kButtonColor,
                        ),
                        height: 50.0,
                        width: 50.0,
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data.isEmpty) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            opacity: 0.5,
                            image:
                                AssetImage('assets/graphics/FoodResQ-logo.png'),
                            fit: BoxFit.contain,
                          ),
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
                            return Container(
                              padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange.shade50,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: calculateDaysLeft(
                                                              date: snapshot
                                                                  .data[index]
                                                                  .expiryDate) >
                                                          3
                                                      ? Colors.green
                                                      : calculateDaysLeft(
                                                                  date: snapshot
                                                                      .data[
                                                                          index]
                                                                      .expiryDate) >=
                                                              0
                                                          ? Colors.orange
                                                          : Colors.red,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: calculateDaysLeft(
                                                            date: snapshot
                                                                .data[index]
                                                                .expiryDate) >
                                                        3
                                                    ? Text("Good")
                                                    : calculateDaysLeft(
                                                                date: snapshot
                                                                    .data[index]
                                                                    .expiryDate) >=
                                                            0
                                                        ? Text("Expire \n Soon")
                                                        : Text("Expired"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${snapshot.data[index].ingredientName}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                calculateDaysLeft(
                                                            date: snapshot
                                                                .data[index]
                                                                .expiryDate) >=
                                                        0
                                                    ? Text(
                                                        "${calculateDaysLeft(date: snapshot.data[index].expiryDate)} days left",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: calculateDaysLeft(
                                                                      date: snapshot
                                                                          .data[
                                                                              index]
                                                                          .expiryDate) >
                                                                  3
                                                              ? Colors.green
                                                              : Colors.orange,
                                                        ),
                                                      )
                                                    : Text(
                                                        "Expired ${-calculateDaysLeft(date: snapshot.data[index].expiryDate)} days ago",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  "Expires on: ${reformatDate(date: snapshot.data[index].expiryDate)}",
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              icon: Icon(Icons.restaurant),
                                              iconSize: 25,
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                        return AlertDialog(
                                                          scrollable: true,
                                                          title: Center(
                                                            child: Text(
                                                                'Consume Ingredient'),
                                                          ),
                                                          content: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Have you consumed this ingredient?",
                                                                ),
                                                                SizedBox(
                                                                  height: 20.0,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          bool
                                                                              successConsume =
                                                                              false;

                                                                          bool
                                                                              success =
                                                                              false;

                                                                          successConsume = await ref.read(ingredientListingRepositoryProvider).consumedIngredient(
                                                                              snapshot.data[index].ingredientName,
                                                                              snapshot.data[index].expiryDate);

                                                                          success = await ref
                                                                              .read(ingredientListingRepositoryProvider)
                                                                              .deleteIngredients(snapshot.data[index].id);

                                                                          if (success &
                                                                              successConsume) {
                                                                            Navigator.pushNamedAndRemoveUntil(
                                                                                context,
                                                                                HomeScreen.routeName,
                                                                                ModalRoute.withName('/'));
                                                                          } else
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Fail to consume!')));
                                                                        },
                                                                        child: Text(
                                                                            "Yes"),
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all<Color>(Colors.transparent),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          10.0,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child: Text(
                                                                            "No"),
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all<Color>(ColourConstant.kButtonColor),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              color: Colors.brown,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      TextButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: Center(
                                                      child: Text(
                                                          'Delete Ingredient'),
                                                    ),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Are you sure you want to \n delete this ingredient?",
                                                          ),
                                                          SizedBox(
                                                            height: 20.0,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    bool
                                                                        success =
                                                                        false;

                                                                    success = await ref
                                                                        .read(
                                                                            ingredientListingRepositoryProvider)
                                                                        .deleteIngredients(snapshot
                                                                            .data[index]
                                                                            .id);

                                                                    if (success) {
                                                                      Navigator.pushNamedAndRemoveUntil(
                                                                          context,
                                                                          HomeScreen
                                                                              .routeName,
                                                                          ModalRoute.withName(
                                                                              '/'));
                                                                    } else
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: const Text('Fail to consume!')));
                                                                  },
                                                                  child: Text(
                                                                      "Yes"),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .transparent),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10.0,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                      "No"),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        ColourConstant
                                                                            .kButtonColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

// @override
// Future<List<Ingredient>> retrieveIngredients() async {

//   final String apiRoute = 'ingredient/$id';
//   var url = Uri.parse(env!.baseUrl + apiRoute);

//   print('Requesting to $url');

//   var response = await http.get(
//     url,
//     headers: {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//     },
//   );

//   print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');

//   var responseBody = response.body;

//   if (response.statusCode == 200) {
//     final results = List<Map<String, dynamic>>.from(json.decode(responseBody));

//     List<Ingredient> items =
//         results.map((item) => Ingredient.fromMap(item)).toList(growable: false);

//     return items;
//   } else {
//     throw CustomException(message: 'Failed to retrieve ingredients!');
//   }
// }

// @override
// Future<bool> deleteIngredients(int ingId) async {
//   final String apiRoute = 'ingredientDelete/$ingId';

//   var url = Uri.parse(env!.baseUrl + apiRoute);

//   print('Requesting to $url');

//   var response = await http.delete(
//     url,
//     headers: {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//     },
//   );

//   print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');

//   var responseBody = response.body;

//   if (response.statusCode == 200) {
//     return true;
//   } else if (response.statusCode == 422) {
//     throw CustomException.fromJson(
//         jsonDecode(responseBody) as Map<String, dynamic>);
//   } else {
//     throw CustomException(message: 'Failed to delete ingredient!');
//   }
// }

String reformatDate(
    {required String date,
    String initialFormat = "yyyy-MM-dd hh:mm:ss",
    // String finalFormat = "dd-MM-yyyy"
    String finalFormat = "d MMM y"}) {
  DateTime newDate = new DateFormat(initialFormat).parse(date);
  String newDateString = DateFormat(finalFormat).format(newDate);

  return newDateString;
}

DateTime convertStrToDate({
  required String date,
  String initialFormat = "yyyy-MM-dd",
}) {
  DateTime newDate = new DateFormat(initialFormat).parse(date);

  return newDate;
}

int calculateDaysLeft({required String date}) {
  DateTime expDate = convertStrToDate(date: date);
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String todayDate = dateFormat.format(DateTime.now());
  DateTime dateNow = convertStrToDate(date: todayDate);

  int daysLeft = expDate.difference(dateNow).inDays;

  return daysLeft;
}

// consumed ingredient api
@override
Future<bool> consumedIngredient(
    int userId, String ingredientName, String expiryDate) async {
  final String apiRoute = 'consumed_ingredient';

  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  // String expiryDateString = dateFormat.format(expiryDate);

  // print(expiryDateString);

  var url = Uri.parse(env!.baseUrl + apiRoute);
  //var url = Uri.parse('http://127.0.0.1:8000/api/' + apiRoute);

  print('Requesting to $url');

  var response = await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      'user_id': userId,
      'ingredient_name': ingredientName,
      'expiry_date': expiryDate
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var responseBody = response.body;

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 422) {
    throw CustomException.fromJson(
        jsonDecode(responseBody) as Map<String, dynamic>);
  } else {
    throw CustomException(message: 'Failed!');
  }
}
