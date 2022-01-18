import 'package:flutter/material.dart';
import 'package:foodresq/component/default_button.dart';
import 'package:foodresq/component/no_account_text.dart';
import 'package:foodresq/component/normal_text.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/constants/dialog.dart';
import 'package:foodresq/controller/auth_controller.dart';
import 'package:foodresq/controller/exception_controller.dart';

import 'package:foodresq/controller/general_controller.dart';
import 'package:foodresq/controller/sign_in_controller.dart';
import 'package:foodresq/models/custom_exception.dart';

import 'package:foodresq/screen/home.dart';
import 'package:foodresq/utilities/size_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInScreen extends HookConsumerWidget {
  static String routeName = "/sign_in";
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          // fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.08),
                      SignInForm(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      NoAccountText(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends HookConsumerWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInControllerState = ref.watch(signInController);
    final signInObscureTextControllerState =
        ref.watch(signInObscureTextController);

    return Column(
      children: [
        buildLoginInfoTextFormField(signInControllerState, ref),
        SizedBox(height: getProportionateScreenHeight(30)),
        buildPasswordTextFormField(
            signInObscureTextControllerState, signInControllerState, ref),
        SizedBox(height: getProportionateScreenHeight(30)),
        DefaultButton(
          text: "Sign In",
          press: () async {
            showLoadingDialog(context: context);
            bool isSucess = await ref.read(signInController).submitData();
            Navigator.of(context).pop();
            print(isSucess);
            if (isSucess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, ModalRoute.withName('/'));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Invalid login details!"),
                ),
              );
            }
          },
          isPrimary: signInControllerState.isFilled,
        ),
        SizedBox(height: getProportionateScreenHeight(15)),
      ],
    );
  }

  TextFormField buildLoginInfoTextFormField(
      SignInController signInControllerState, WidgetRef ref) {
    return TextFormField(
      // autofocus: true,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: signInControllerState.loginInfo.error,
        hintText: "Enter email",
      ),
      onChanged: (String value) {
        ref.read(signInController).changeloginInfo(value);
      },
    );
  }

  TextFormField buildPasswordTextFormField(
      SignInObscureTextController signInObscureTextControllerState,
      SignInController signInControllerState,
      WidgetRef ref) {
    return TextFormField(
      obscureText: signInObscureTextControllerState.isTrue,
      decoration: InputDecoration(
        labelText: "Password",
        errorText: signInControllerState.password.error,
        hintText: "Enter password",
        suffixIcon: IconButton(
          icon: signInObscureTextControllerState.switchObsIcon,
          onPressed: () => ref.read(signInObscureTextController).toggleObs(),
        ),
      ),
      onChanged: (String value) {
        ref.read(signInController).changePassword(value);
      },
    );
  }
}
