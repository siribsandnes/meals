import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

//with allowws you to add a "mixin" to a class: Another class being merged to this class behind the scenes and therefor offering socalld features
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController
      _animationController; //Cant be intiialized here. nedd initState . //late tells dart this variable will have value as sonn as used first time, but not when class is created

//Initialises the state
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController
        .dispose(); //Makes sure this animationController is removed from device memory once widget is removed.
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final List<Meal> filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList(); //Selects the meals in dummymeals witht the correct category and creates a new list with only those meals

    //Must accept context here. Not globally available in statelesswidget
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealsScreen(
            title: category.title,
            meals: filteredMeals,
          ),
        )); //Pushes the "route widget" as the top layer and makes it visible.
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //Controls layout of the gridviewItems, complex way of saying i can set number of column
          crossAxisCount: 2, //Two columns
          childAspectRatio: 3 / 2, //Impacts sizing of grid items
          crossAxisSpacing: 20, //Spacing between columns
          mainAxisSpacing: 20, //Spacing between items horizontally
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),
        ],
      ), // here you can have items that will not be animated
      builder: (contex, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3), // Where animation should start
            end: const Offset(0, 0), //End on actual normal postion
          ).animate(CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut)),
          child: child),
    );
  }
}
