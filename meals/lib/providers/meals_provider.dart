import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';

//Must use this to update meals when adding new meal. Change the provider and make addMeals a consumer
final mealsProvider = Provider((ref) {
  return dummyMeals;
});
