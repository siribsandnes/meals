import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(
      {super.key,
      this.title,
      required this.meals,
      required this.onToggleFavorite});

  final String? title;
  final List<Meal> meals;
  final Function(Meal meal) onToggleFavorite;

  void _selectMeal(BuildContext context, Meal meal) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealDetails(
            meal: meal,
            onToggleFavorite: onToggleFavorite,
          ),
        )); //Pushes the "route widget" as the top layer and makes it visible.
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => MealItem(
        meal: meals[index],
        onSelectMeal: () {
          _selectMeal(context, meals[index]);
        },
      ),
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh.. nothing here!',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Try selecting a different category',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ],
        ),
      );
    }

    //If title is not set you only return content
    if (title == null) {
      return content;
    }

    //If title is set you return scaffold with set title
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
