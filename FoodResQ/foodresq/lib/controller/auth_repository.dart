import 'dart:convert';

import 'package:foodresq/controller/auth_controller.dart';
import 'package:foodresq/models/user_model.dart';
import 'package:foodresq/utilities/user_shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;


import '../env.dart';
import '../models/custom_exception.dart';

abstract class BaseAuthRepository {
  Future<User> getCurrentUser();
  Future<User> signIn({required String loginInfo, required String password});
  Future<User> signUp(
      {required String fullname,
      required String email,
      required String password,});

  // Future<User> updateUserDetails({
  //   required String fullname,
  //   required String email,
  // });
  Future<void> signOut();
  Future<int> getUserIdByEmail({
    email = null,
    studentEmail = null,
  });
  Future<bool> changePassword({required int id, required String password});
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository implements BaseAuthRepository {
  // You can refer to other provider with this (must initialize in constructor)
  final Reader _read;

  const AuthRepository(this._read);

  @override
  Future<User> getCurrentUser() async {
    final String apiRoute = 'me';

    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_accesToken',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // var responseBody = json.decode(response.body);
    var responseBody = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(responseBody);
    } else {
      throw response.statusCode;
    }
  }

  @override
  Future<void> signOut() async {
    final String apiRoute = 'logout';

    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_accesToken',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // var responseBody = json.decode(response.body);
    // var responseBody = response.body;

    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   throw response.statusCode;
    // }
  }

  @override
  Future<User> signIn(
      {required String loginInfo, required String password}) async {
    final String apiRoute = 'login';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // 'Authorization': 'Bearer $accesToken',
      },
      body: jsonEncode({'login': loginInfo, 'password': password}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // var responseBody = json.decode(response.body);
    var responseBody = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(responseBody);
    } else {
      // print(responseBody['message']);
      // if (response.statusCode == 422) {
      //   print(jsonDecode(responseBody['errors']));
      // }
      // String message = responseBody['message'].toString();
      // throw const CustomException(message: message);

      // throw CustomException.fromJson(
      //     jsonDecode(responseBody) as Map<String, dynamic>);

      // TODO: MANAGE Response status: 404

      throw CustomException.fromJson(
          jsonDecode(responseBody) as Map<String, dynamic>);
    }
  }

  @override
  Future<User> signUp(
      {required String fullname,
      required String email,
      required String password,
      String? referbyID}) async {
    final String apiRoute = 'register';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // 'Authorization': 'Bearer $accesToken',
      },
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'password': password,
        'referby_id': referbyID
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(responseBody);
    } else {
      throw CustomException.fromJson(
          jsonDecode(responseBody) as Map<String, dynamic>);
    }
  }

  @override
  Future<String> requestOTP({
    required int id,
    required String email,
  }) async {
    final String apiRoute = 'request_otp';
    // final String? token =
    //     _read(authControllerProvider.notifier).getAccessToken();

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({'email': email, 'id': id}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      return json.decode(responseBody)['otp'];
    } else {
      // throw CustomException.fromJson(
      //     jsonDecode(responseBody) as Map<String, dynamic>);
      throw CustomException(message: 'Failed to generate your OTP!');
    }
  }

  @override
  Future<User> updateVerificationDetails({
    required String fullname,
    required String gender,
    required String dob,
    required int universityId,
    required int fieldId,
    required String studentEmail,
  }) async {
    final String token = _read(authControllerProvider).accessToken!;
    final int id = _read(authControllerProvider).id!;

    final String apiRoute = 'update_verification_details/$id';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fullname': fullname,
        'gender': gender,
        'dob': dob,
        'university_id': universityId,
        'field_id': fieldId,
        'student_email': studentEmail,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      // return json.decode(responseBody)['success'];
      return User.fromJson(responseBody);
    } else {
      // throw CustomException.fromJson(
      //     jsonDecode(responseBody) as Map<String, dynamic>);
      throw CustomException(message: 'Failed to update user information!');
    }
  }

  @override
  Future<bool> validateUniqueStudentEmail(
      {required String studentEmail}) async {
    final String apiRoute = 'validate_unique_student_email';

    final String? token = _read(authControllerProvider).accessToken;

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'student_email': studentEmail}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException.fromJson(
          jsonDecode(responseBody) as Map<String, dynamic>);
    }
  }

  // @override
  // Future<User> socialLogin({required SocialLoginInfo socialLogin}) async {
  //   final String apiRoute = 'social_login';

  //   var url = Uri.parse(env!.baseUrl + apiRoute);
  //   print('Requesting to $url');
  //   var response = await http.post(
  //     url,
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       // 'Authorization': 'Bearer $accesToken',
  //     },
  //     body: socialLogin.toJson(),
  //   );
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');

  //   var responseBody = response.body;

  //   if (response.statusCode == 200) {
  //     return User.fromJson(responseBody);
  //   } else {
  //     throw CustomException.fromJson(
  //         jsonDecode(responseBody) as Map<String, dynamic>);
  //   }
  // }

  // @override
  // Future<User> updateUserDetails(
  //     {required String fullname,
  //     required String gender,
  //     required String dob,
  //     required String graduationYear,
  //     required int fieldId,
  //     required String email}) async {
  //   final String token = _read(authControllerProvider).accessToken!;
  //   final int id = _read(authControllerProvider).id!;

  //   final String apiRoute = 'update_user_details/$id';

  //   var url = Uri.parse(env!.baseUrl + apiRoute);
  //   print('Requesting to $url');

  //   var response = await http.put(
  //     url,
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({
  //       'fullname': fullname,
  //       'gender': gender,
  //       'dob': dob,
  //       'graduation_year': graduationYear,
  //       'field_id': fieldId,
  //       'email': email,
  //     }),
  //   );

  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');

  //   var responseBody = response.body;

  //   if (response.statusCode == 200) {
  //     // return json.decode(responseBody)['success'];
  //     return User.fromJson(responseBody);
  //   } else {
  //     // throw CustomException.fromJson(
  //     //     jsonDecode(responseBody) as Map<String, dynamic>);
  //     throw CustomException(message: 'Failed to update user information!');
  //   }
  // }

  @override
  Future<int> getUserIdByEmail({email = null, studentEmail = null}) async {
    final String apiRoute = 'get_user_id_by_email';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({'email': email, 'student_email': studentEmail}),
    );

    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      return checkAndReturnInt(json.decode(responseBody)['id']);
    } else {
      throw CustomException(message: "Email not found");
    }
  }

  @override
  Future<bool> changePassword(
      {required int id, required String password}) async {
    final String apiRoute = 'change_password';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({'id': id, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      return json.decode(responseBody)['success'];
    } else {
      throw CustomException(message: "Failed to update password");
    }
  }
}
