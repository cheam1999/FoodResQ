import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/models/recipes_model.dart';
import '../models/custom_exception.dart';
import 'package:foodresq/repositories/recipes_repository.dart';

final recipesControllerProvider = StateNotifierProvider.autoDispose
    .family<RecipesController, AsyncValue<List<Recipes>>, String>(
        (ref, listType) {
  return RecipesController(ref.read, listType);
});

class RecipesController extends StateNotifier<AsyncValue<List<Recipes>>> {
  final Reader _read;
  final String _listType;

  RecipesController(this._read, this._listType) : super(AsyncLoading()) {
    retrieveRecipes();
  }

  Future<void> retrieveRecipes({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    await Future.delayed(Duration(milliseconds: 500));
    print(this._listType);
    try {
      final recipes = await _read(recipesRepositoryProvider).retrieveRecipes();
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, stackTrace: st);
    } catch (e) {
      //TODO: handle error
      state = AsyncValue.error(e);
    }
  }
}
