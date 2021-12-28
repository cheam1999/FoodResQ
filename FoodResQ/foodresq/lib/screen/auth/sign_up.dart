import 'package:flutter/material.dart';
import 'package:foodresq/component/default_button.dart';
import 'package:foodresq/constants/dialog.dart';
import 'package:foodresq/controller/general_controller.dart';
import 'package:foodresq/controller/sign_up_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../size_config.dart';

class SignUpScreen extends HookConsumerWidget {
  static String routeName = "/sign_up";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          // fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
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
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.08),
                  SignUpForm(), // Form
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends HookConsumerWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpControllerState = ref.watch(signUpController);
    final signUpObscureTextControllerState =
        ref.watch(signUpObscureTextController);
    return Column(
      children: [
        // Fullname
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: "Fullname",
            errorText: signUpControllerState.fullname.error,
            hintText: "Enter your name",
          ),
          onChanged: (String value) {
            ref.read(signUpController).changeFullname(value);
          },
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        //Email
        TextFormField(
          decoration: InputDecoration(
            labelText: "Email",
            errorText: signUpControllerState.email.error,
            hintText: "Enter email",
          ),
          onChanged: (String value) {
            ref.read(signUpController).changeEmail(value);
          },
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        //Password
        TextFormField(
          obscureText: signUpObscureTextControllerState.isTrue,
          decoration: InputDecoration(
            labelText: "Password",
            errorText: signUpControllerState.password.error,
            hintText: "Enter password",
            suffixIcon: IconButton(
              icon: signUpObscureTextControllerState.switchObsIcon,
              onPressed: () =>
                  ref.read(signUpObscureTextController).toggleObs(),
            ),
          ),
          onChanged: (String value) {
            ref.read(signUpController).changePassword(value);
          },
        ),
        // SizedBox(height: getProportionateScreenHeight(30)),
        // // Referral Code
        // TextFormField(
        //   decoration: InputDecoration(
        //     labelText: "Referral Code",
        //     errorText: signUpControllerState.password.error,
        //     hintText: "Enter referral code (optional)",
        //   ),
        //   onChanged: (String value) {
        //     ref.read(signUpController).changePassword(value);
        //   },
        // ),
        SizedBox(height: getProportionateScreenHeight(30)),
        DefaultButton(
          text: "Sign Up",
          press: () async {
            showLoadingDialog(context: context);
            bool isSucess = await ref.read(signUpController).submitData();
            Navigator.of(context).pop();
            print(isSucess);
            if (isSucess) print("success");
            // Navigator.pushNamedAndRemoveUntil(context,
            //     VerificationScreen.routeName, ModalRoute.withName('/'));
          },
          isPrimary: signUpControllerState.isFilled,
        ),
      ],
    );
  }
}
