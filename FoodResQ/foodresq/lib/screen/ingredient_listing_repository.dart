import 'dart:convert';
import 'package:foodresq/controller/auth_controller.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/models/ingredient_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

abstract class BaseIngredientRepository {}

final IngredientRepositoryProvider =
    Provider<IngredientRepository>((ref) => IngredientRepository(ref.read));

class IngredientRepository implements BaseIngredientRepository {
  final Reader _read;
  const IngredientRepository(this._read);

@override
Future<List<Ingredient>> retrieveIngredients() async {

  final int id =  _read(authControllerProvider).id!;
  final String apiRoute = 'ingredient/$id';
  var url = Uri.parse(env!.baseUrl + apiRoute);

  print('Requesting to $url');

  var response = await http.get(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var responseBody = response.body;

  if (response.statusCode == 200) {
    final results = List<Map<String, dynamic>>.from(json.decode(responseBody));

    List<Ingredient> items =
        results.map((item) => Ingredient.fromMap(item)).toList(growable: false);

    return items;
  } else {
    throw CustomException(message: 'Failed to retrieve ingredients!');
  }
}

@override
Future<bool> deleteIngredients(int ingId) async {

  final String apiRoute = 'ingredientDelete/$ingId';
  var url = Uri.parse(env!.baseUrl + apiRoute);

  print('Requesting to $url');

  var response = await http.delete(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var responseBody = response.body;

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 422) {
    throw CustomException.fromJson(
        jsonDecode(responseBody) as Map<String, dynamic>);
  } else {
    throw CustomException(message: 'Failed to delete ingredient!');
  }
}

@override
Future<bool> saveIngredient(String ingredientName, DateTime expiryDate) async {
  final int userId =  _read(authControllerProvider).id!;
  final String apiRoute = 'save_ingredient';

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String expiryDateString = dateFormat.format(expiryDate);

  print(expiryDateString);

  var url = Uri.parse(env!.baseUrl + apiRoute);
  //var url = Uri.parse('http://127.0.0.1:8000/api/' + apiRoute);

  print('Requesting to $url');

  var response = await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      'user_id': userId,
      'ingredient_name': ingredientName,
      'expiry_date': expiryDateString
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var responseBody = response.body;

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 422) {
    throw CustomException.fromJson(
        jsonDecode(responseBody) as Map<String, dynamic>);
  } else {
    throw CustomException(message: 'Failed to save ingredient!');
  }
}
}
