import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodresq/constants/errorMessage.dart';
import 'package:foodresq/controller/auth_controller.dart';
import 'package:foodresq/controller/validation_itm_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:ugek_mobile_v1/screens/home.dart';

final signUpController = ChangeNotifierProvider.autoDispose<SignUpController>(
    (ref) => SignUpController(ref.read));

class SignUpController extends ChangeNotifier {
  final Reader _read;

  SignUpController(this._read);

  // final int _usernameLength = 3;
  final int _fullnameLength = 1;
  final int _passwordInfoLength = 8;

  // ValidationItem _username = ValidationItem(null, null);
  ValidationItem _fullname = ValidationItem(null, null);
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  // Decalre getters
  // ValidationItem get username => _username;
  ValidationItem get fullname => _fullname;
  ValidationItem get email => _email;
  ValidationItem get password => _password;

  bool get isValid {
    if (isFullnameValid && isPasswordValid && isEmailValid) return true;
    return false;
  }

  bool get isFilled {
    if (_fullname.value != null &&
        _email.value != null &&
        _password.value != null &&
        _fullname.value!.length > 0 &&
        _email.value!.length > 0 &&
        _password.value!.length > 0) return true;
    return false;
  }

  bool get isFullnameValid {
    if (_fullname.value != null && _fullname.value!.length >= _fullnameLength)
      return true;
    return false;
  }

  bool get isEmailValid {
    if (_email.value != null && EmailValidator.validate(_email.value ?? ''))
      return true;
    return false;
  }

  bool get isPasswordValid {
    if (_password.value != null &&
        _password.value!.length >= _passwordInfoLength) return true;
    return false;
  }

  // Declare setters
  void changeFullname(String value) {
    print('Fullname: $value');
    _fullname = ValidationItem(value, null);

    notifyListeners();
  }

  void changeEmail(String value) {
    print('Email: $value');
    _email = ValidationItem(value, null);

    notifyListeners();
  }

  void changePassword(String value) {
    print('Password: $value');
    _password = ValidationItem(value, null);

    notifyListeners();
  }

  //TODO: Revise this validation method
  void editErrorMessage(
      {required String fieldType, required String errorText}) {
    switch (fieldType) {
      case 'fullname':
        _fullname = ValidationItem(_fullname.value, errorText);
        break;
      case 'email':
        _email = ValidationItem(_email.value, errorText);

        break;
      case 'password':
        _password = ValidationItem(_password.value, errorText);
        break;
    }
    notifyListeners();
  }

  Future<bool> submitData() async {

    if (isValid) {
      print(
          "Fullname: ${fullname.value}, Email: ${email.value},Password: ${_password.value}");

      bool isSuccess = await _read(authControllerProvider.notifier).signUp(
          fullname: fullname.value!.trim(),
          email: email.value!.trim(),
          password: _password.value!,
          );

      return isSuccess;
    } else {
      if (!isFullnameValid)
        _fullname = ValidationItem(
            _fullname.value,
            ErrorMessages.enterMinimumCharactersErrorMessage(
                _fullnameLength.toString()));

      if (!isEmailValid)
        _email = ValidationItem(
            _email.value, ErrorMessages.enterEmailAddressErrorMessage);

      if (!isPasswordValid)
        _password = ValidationItem(
            _password.value,
            ErrorMessages.enterMinimumCharactersErrorMessage(
                _passwordInfoLength.toString()));
      notifyListeners();
    }
    return false;
  }
}
