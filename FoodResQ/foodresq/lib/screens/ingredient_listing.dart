import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/models/ingredient_model.dart';
import 'package:foodresq/screens/add_ingredient.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class IngredientListingPage extends StatefulWidget {
  const IngredientListingPage({Key? key}) : super(key: key);

  @override
  _IngredientListingPageState createState() => _IngredientListingPageState();
}

class _IngredientListingPageState extends State<IngredientListingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ingredients"),
        backgroundColor: Colors.brown,
      ),
      body: SafeArea(
        child: Container(
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
              future: retrieveIngredients(3),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "No Ingredient Saved",
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
                                    EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                .data[index]
                                                                .expiryDate) >=
                                                        0
                                                    ? Colors.orange
                                                    : Colors.red,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: calculateDaysLeft(
                                                      date: snapshot.data[index]
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
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          calculateDaysLeft(
                                                      date: snapshot.data[index]
                                                          .expiryDate) >=
                                                  0
                                              ? Text(
                                                  "${calculateDaysLeft(date: snapshot.data[index].expiryDate)} days left",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: calculateDaysLeft(
                                                                date: snapshot
                                                                    .data[index]
                                                                    .expiryDate) >
                                                            3
                                                        ? Colors.green
                                                        : Colors.orange,
                                                  ),
                                                )
                                              : Text(
                                                  "Expired ${-calculateDaysLeft(date: snapshot.data[index].expiryDate)} days ago",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                        icon: Icon(Icons.delete),
                                        iconSize: 30,
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

                                                                    success = await deleteIngredients(
                                                                        snapshot
                                                                            .data[index]
                                                                            .id);

                                                                    if (success) {
                                                                      Navigator
                                                                          .pushAndRemoveUntil(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                IngredientListingPage()),
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false,
                                                                      );
                                                                    } else
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: const Text('Fail to delete!')));
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
                                                                        Colors
                                                                            .brown),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Ingredient",
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddIngredientPage(title: 'Add Ingredient')),
          );
        },
        child: Icon(
          Icons.add,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: Colors.brown,
      ),
    );
  }
}

@override
Future<List<Ingredient>> retrieveIngredients(int userId) async {
  final String apiRoute = 'ingredient/$userId';

  var url = Uri.parse('http://192.168.0.122:8000/api/' + apiRoute);

  print('Requesting to $url');

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

    List<Ingredient> items =
        results.map((item) => Ingredient.fromMap(item)).toList(growable: false);

    return items;
  } else {
    throw CustomException(message: 'Failed to retrieve ingredients!');
  }
}

@override
Future<bool> deleteIngredients(int ingId) async {
  final String apiRoute = 'ingredientDelete/$ingId';

  var url = Uri.parse('http://192.168.0.122:8000/api/' + apiRoute);

  print('Requesting to $url');

  var response = await http.delete(
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
    return true;
  } else if (response.statusCode == 422) {
    throw CustomException.fromJson(
        jsonDecode(responseBody) as Map<String, dynamic>);
  } else {
    throw CustomException(message: 'Failed to delete ingredient!');
  }
}

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
