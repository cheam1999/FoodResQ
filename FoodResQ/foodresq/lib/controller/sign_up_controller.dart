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

  // final int _nameLength = 3;
  final int _nameLength = 1;
  final int _passwordInfoLength = 8;

  // ValidationItem _name = ValidationItem(null, null);
  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
  //ValidationItem _passwordConfirmation = ValidationItem(null, null);

  // Decalre getters
  // ValidationItem get name => _name;
  ValidationItem get name => _name;
  ValidationItem get email => _email;
  ValidationItem get password => _password;
  //ValidationItem get passwordConfirmation => _passwordConfirmation;

  bool get isValid {
    if (isnameValid &&
        isPasswordValid &&
        isEmailValid 
        //isPasswordConfirmationValid
        ) return true;

    return false;
  }

  bool get isFilled {
    if (_name.value != null &&
        _email.value != null &&
        _password.value != null &&
        //_passwordConfirmation.value != null &&
        _name.value!.length > 0 &&
        _email.value!.length > 0 &&
        _password.value!.length > 0 
        //_passwordConfirmation.value!.length > 0
        ) return true;
    return false;
  }

  bool get isnameValid {
    if (_name.value != null && _name.value!.length >= _nameLength) return true;
    return false;
  }

  bool get isPasswordValid {
    if (_password.value != null &&
        _password.value!.length >= _passwordInfoLength) return true;
    return false;
  }

  // bool get isPasswordConfirmationValid {
  //   if (_passwordConfirmation.value == _password.value) return true;
  //   return false;
  // }

  bool get isEmailValid {
    if (_email.value != null && EmailValidator.validate(_email.value ?? ''))
      return true;
    return false;
  }

  // Declare setters
  void changename(String value) {
    print('name: $value');
    _name = ValidationItem(value, null);

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

  // void changeConfirmationPassword(String value) {
  //   print('Password confirm: $value');
  //   _passwordConfirmation = ValidationItem(value, null);

  //   notifyListeners();
  // }

  //TODO: Revise this validation method
  void editErrorMessage(
      {required String fieldType, required String errorText}) {
    switch (fieldType) {
      case 'name':
        _name = ValidationItem(_name.value, errorText);
        break;
      case 'email':
        _email = ValidationItem(_email.value, errorText);
        break;
      case 'password':
        _password = ValidationItem(_password.value, errorText);
        break;
      // case 'password_confirmation':
      //   _passwordConfirmation =
      //       ValidationItem(_passwordConfirmation.value, errorText);
      //   break;
    }
    notifyListeners();
  }

  Future<bool> submitData() async {
    if (isValid) {

      bool isSuccess = await _read(authControllerProvider.notifier).signUp(
        name: name.value!.trim(),
        email: email.value!.trim(),
        password: _password.value!,
        //password_confirmation: _passwordConfirmation.value!,
      );
      print("success: $isSuccess");
      return isSuccess;
    } else {
      if (!isnameValid)
        _name = ValidationItem(
            _name.value,
            ErrorMessages.enterMinimumCharactersErrorMessage(
                _nameLength.toString()));
      if (!isEmailValid)
        _email = ValidationItem(
            _email.value, ErrorMessages.enterEmailAddressErrorMessage);
      if (!isPasswordValid)
        _password = ValidationItem(
            _password.value,
            ErrorMessages.enterMinimumCharactersErrorMessage(
                _passwordInfoLength.toString()));
      notifyListeners();

      // if (!isPasswordConfirmationValid)
      //   _passwordConfirmation = ValidationItem(
      //       _passwordConfirmation.value,
      //       ErrorMessages.enterMinimumCharactersErrorMessage(
      //           _passwordInfoLength.toString()));
      // notifyListeners();
    }
    return false;
  }
}
