import 'package:flutter/material.dart';
import 'package:foodresq/component/default_button.dart';
import 'package:foodresq/controller/auth_controller.dart';
import 'package:foodresq/controller/auth_repository.dart';
import 'package:foodresq/screen/auth/sign_in.dart';
import 'package:foodresq/utilities/size_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void showLoadingDialog({required BuildContext context}) => showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  "Loading...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
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

void showLogoutDialog({
  required BuildContext context,
  required Function confirmEvent,
  String confirmTitle = "Exit?",
  String? confirmDescription = "Are you sure you want to exit?",
  String confirmButtonLabel = "Yes",
  String backButtonLabel = "Cancel",
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
                // Image.asset(
                //   "assets/icons/alert.png",
                //   height: SizeConfig.screenHeight! * 0.1,
                // ),
                Text(
                  confirmTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenHeight(20),
                  ),
                ),
                if (confirmDescription != null)
                  Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        confirmDescription,
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
                        text: confirmButtonLabel,
                        press: () {
                          // TODO: Need progress indicator (circular?)
                          Navigator.of(context).pop();
                          confirmEvent();
                        }),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    DefaultButton(
                      text: backButtonLabel,
                      press: () {
                        Navigator.of(context).pop();
                      },
                      isPrimary: false,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
