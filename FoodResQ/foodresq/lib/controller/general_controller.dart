import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final obscureTextController = ChangeNotifierProvider.autoDispose
    .family<ObscureTextController, String>(
        (ref, type) => ObscureTextController(ref.read, type));

class ObscureTextController extends ChangeNotifier {
  // const SignInObscureTextController({Key? key}) : super(key: key);
  final Reader _read;
  final String _type;

  ObscureTextController(this._read, this._type);

  bool _isTrue = true;
  bool get isTrue => _isTrue;

  get switchObsIcon {
    return _isTrue ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
  }

  void toggleObs() {
    _isTrue = !_isTrue;
    print('Obscure: $_isTrue');
    notifyListeners();
  }
}

final signInObscureTextController =
    ChangeNotifierProvider.autoDispose<SignInObscureTextController>(
        (ref) => SignInObscureTextController());

final signUpObscureTextController =
    ChangeNotifierProvider.autoDispose<SignUpObscureTextController>(
        (ref) => SignUpObscureTextController());

// Two providers with same type and implementation (intended for now)
//TODO: change to .family maybe?

class SignInObscureTextController extends ChangeNotifier {
  // const SignInObscureTextController({Key? key}) : super(key: key);
  bool _isTrue = true;
  bool get isTrue => _isTrue;

  get switchObsIcon {
    return _isTrue ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
  }

  void toggleObs() {
    _isTrue = !_isTrue;
    print('Obscure: $_isTrue');
    notifyListeners();
  }
}

class SignUpObscureTextController extends ChangeNotifier {
  // const SignUpObscureTextController({Key? key}) : super(key: key);
  bool _isTrue = true;
  bool get isTrue => _isTrue;

  get switchObsIcon {
    return _isTrue ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
  }

  void toggleObs() {
    _isTrue = !_isTrue;
    print('Obscure: $_isTrue');
    notifyListeners();
  }
}
