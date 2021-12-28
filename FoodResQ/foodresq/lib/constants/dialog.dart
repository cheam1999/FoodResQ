import 'package:flutter/material.dart';
import 'package:foodresq/component/default_button.dart';

import '../size_config.dart';

void showLoadingDialog({required BuildContext context}) => showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Loading...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 50),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );


void showErrorDialog({
  required BuildContext context,
  required Function action,
  String title = "Error!",
  String? error = null,
  String buttonLabel = "Retry",
}) =>
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenHeight(20),
                  ),
                ),
                if (error != null)
                  Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(15),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Column(
                  children: [
                    DefaultButton(
                      text: buttonLabel,
                      press: () {
                        action();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );