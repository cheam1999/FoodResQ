import 'dart:convert';
import 'dart:ffi';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/models/recipes_model.dart';
import 'package:http/http.dart' as http;
import '../models/custom_exception.dart';

abstract class BaseRecipesRepository {
  Future<List<Recipes>> retrieveRecipes();
}

final recipesRepositoryProvider =
    Provider<RecipesRepository>((ref) => RecipesRepository(ref.read));

class RecipesRepository implements BaseRecipesRepository {
  final Reader _read;
  const RecipesRepository(this._read);

  @override
  Future<List<Recipes>> retrieveRecipes() async {
    final String apiRoute = 'get_recipe';
    var url = Uri.parse(env!.baseUrl + apiRoute);
    print("Requesting to $url");

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
      final results =
          List<Map<String, dynamic>>.from(json.decode(responseBody));

      List<Recipes> items =
          results.map((item) => Recipes.fromMap(item)).toList(growable: false);

      return items;
    } else {
      throw CustomException(message: 'Failed to retrieve recipe!');
    }
  }
}
