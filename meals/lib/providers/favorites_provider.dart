import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

// Norm is to end this class with notifier but you can call it whatever
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  //Updates state in immutable way (without editing existing state in memory)
  //Remember: Must allways create new value cannot edit an existing one.
  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsfavorite =
        state.contains(meal); //Allowed does not change anything just checks

    if (mealIsfavorite) {
      state = state
          .where((m) => m.id != meal.id)
          .toList(); //Allowed you are not changing the data you are creating a new list
      return false;
    } else {
      state = [
        ...state,
        meal
      ]; //... "spread operator" takes the element of the list and add them as individual elements in new list
      return true;
    }
  }
}

//Returns instance of Notifier Class. Must specify which data the notifier yields:
//Hence <FavoriteMealsNotifier, List<Meal>>
final favoritesProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
