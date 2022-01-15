import 'package:flutter/material.dart';
import 'package:foodresq/size_config.dart';

import 'default_button.dart';
import 'normal_text.dart';

class ItemListError extends StatelessWidget {
  const ItemListError({
    Key? key,
    required this.message,
    required this.press,
  }) : super(key: key);

  final String message;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NormalText(
            text: message,
            fontSize: 15,
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          //TODO: set padding to this button
          DefaultButton(
            text: 'Retry',
            press: press,
          )
        ],
      ),
    );
  }
}
