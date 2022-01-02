import 'package:foodresq/controller/auth_repository.dart';
import 'package:foodresq/controller/exception_controller.dart';
import 'package:foodresq/controller/sign_up_controller.dart';
import 'package:foodresq/models/custom_exception.dart';

import 'package:foodresq/models/user_model.dart';
import 'package:foodresq/utilities/user_shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, User>((ref) {
  // return AuthController(ref.read)..appStarted();
  return AuthController(ref.read);
});

class AuthController extends StateNotifier<User> {
  final Reader _read;
  // final ProviderRefBase ref;
  // BaseAuthRepository _baseAuthRepository;

  AuthController(this._read) : super(User());

  Future appStarted() async {
    print('App Started!');

    // Check Login Status
    bool _isLogin = await UserSharedPreferences.getLoginStatus() ?? false;

    if (_isLogin) {
      String? _accessToken =
          await UserSharedPreferences.getAccessToken() ?? null;

      if (_accessToken == null) {
        //TODO: do something if access token is null
      } else {
        String? _tokenType = await UserSharedPreferences.getTokenType() ?? null;
        try {
          User _currentUser =
              await _read(authRepositoryProvider).getCurrentUser();

          _currentUser = _currentUser.copyWith(
              accessToken: _accessToken,
              tokenType: _tokenType,
              isLogin: _isLogin);

          state = _currentUser;

          print('SharedPreferences:');
          print(state.tokenType);
          print(state.accessToken);
          print(state.isLogin);
        } catch (statusCode) {
          if (statusCode == 401)
            signOut();
          else
            throw (statusCode);
        }
      }
    }
  }

  Future updateReferralCount() async {
    // await _read(authRepositoryProvider).getCurrentUser();
    User _user = await _read(authRepositoryProvider).getCurrentUser();
    User newState = _user.copyWith(
        accessToken: state.accessToken, tokenType: state.accessToken);
    state = newState;
  }

  void signOut() async {
    print('Sign out user!');

    await _read(authRepositoryProvider).signOut();
    //TODO: log sign out and sign in
    //await _read(authRepositoryProvider).signOut();
    UserSharedPreferences.removeAccessToken();
    UserSharedPreferences.removeLoginStatus();
    UserSharedPreferences.removeLoginStatus();

    // //TODO: switch case maybe?
    // if (state.loginType == LoginType.FACEBOOK) {
    //   await FacebookAuth.instance.logOut();
    //   print('logout fb');
    // } else if (state.loginType == LoginType.GOOGLE) {
    //   await getGoogleLoginScope().signOut();
    //   print('logout google');
    // } else if (state.loginType == LoginType.APPLE) {
    //   print('logout apple');
    //   // Logout Apple ID - no logout method provided by the sign_in_with_apple package
    // } else {
    //   // Logout own login system if implemented
    // }
    state = User();
  }

  Future<bool> signIn(
      {required String loginInfo, required String password}) async {
    //TODO: save token
    try {
      User _user = await _read(authRepositoryProvider)
          .signIn(loginInfo: loginInfo, password: password);

      state = _user;

      UserSharedPreferences.setLoginStatus(true);
      UserSharedPreferences.setAccessToken(state.accessToken!);
      UserSharedPreferences.setTokenType(state.tokenType!);

      print(state.id);

      return true;
    } on CustomException catch (e) {
      _handleException(e);
    } catch (e) {
      //TODO: Apply this to other functions
      _handleException(
        CustomException(message: "Sign In Error!"),
      );
    }

    return false;
  }

  Future<bool> signUp(
      {required String fullname,
      required String email,
      required String password,
      String? referbyID}) async {
    //TODO: save token
    try {
      User _user = await _read(authRepositoryProvider).signUp(
          fullname: fullname,
          email: email,
          password: password,
          referbyID: referbyID);

      state = _user;

      UserSharedPreferences.setLoginStatus(true);
      UserSharedPreferences.setAccessToken(state.accessToken!);
      UserSharedPreferences.setTokenType(state.tokenType!);

      print(state.accessToken);

      return true;
    } on CustomException catch (e) {
      _handleException(e);
    } catch (e) {
      //TODO: Apply this to other functions
      _handleException(
        CustomException(message: "Sign Up Error!"),
      );
    }
    return false;
  }

  // Future<bool> socialLogin({required SocialLoginInfo socialLogin}) async {
  //   try {
  //     User _user = await _read(authRepositoryProvider)
  //         .socialLogin(socialLogin: socialLogin);

  //     state = _user;

  //     UserSharedPreferences.setLoginStatus(true);
  //     UserSharedPreferences.setAccessToken(state.accessToken!);
  //     UserSharedPreferences.setTokenType(state.tokenType!);

  //     print(state.accessToken);

  //     return true;
  //   } on CustomException catch (e) {
  //     _handleException(e);
  //   }
  //   return false;
  // }

  void _handleException(CustomException e) {
   // _read(exceptionControllerProvider).state =  e;
    //TODO: Revise this validation method, try make it for sign up only
    if (e.errors != null) {
      if (e.errors?['fullname'] != null) {
        _read(signUpController.notifier).editErrorMessage(
          fieldType: 'fullname',
          errorText: e.errors!['fullname'][0],
        );
      }

      if (e.errors?['email'] != null) {
        _read(signUpController.notifier).editErrorMessage(
          fieldType: 'email',
          errorText: e.errors!['email'][0],
        );
      }

      if (e.errors?['password'] != null) {
        _read(signUpController.notifier).editErrorMessage(
          fieldType: 'password',
          errorText: e.errors!['password'][0],
        );
      }
    }
  }

  // String? getAccessToken() {
  //   return state.accessToken;
  // }

  void updateUserState({required User updatedUser}) {
    //TODO: Revise this method (maybe divide auth and user model)
    print(state);
    print(updatedUser);
    User newState = updatedUser.copyWith(
        accessToken: state.accessToken, tokenType: state.accessToken);
    print(newState);
    state = newState;
    print('Update verification details:');
    print(state);
  }

  void updateProfileState({required User updatedUser}) {
    //TODO: Revise this method (maybe divide auth and user model)
    print(state);
    print(updatedUser);
    User newState = updatedUser.copyWith(
        accessToken: state.accessToken,
        tokenType: state.accessToken,
        isLogin: true);
    print(newState);
    state = newState;
    print('Update profile details:');
    print(state);
  }
}
