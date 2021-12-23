import 'package:flutter/material.dart';

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
        child: Container(),
      ),
    );
  }
}
