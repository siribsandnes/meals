import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/addIngredients.dart';
import 'package:meals/widgets/addSteps.dart';
import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';

//Should implemet adding ned meal here-

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddMealScreenState();
  }
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final List<String> _listOfIngredients = [];
  final List<String> _listOfSteps = [];
  var _selectedTitle = "";
  var _selectedCategory = availableCategories[1];
  List<String> _selectedCategoryList = [];
  var _selectedAffordability = Affordability.affordable;
  var _selectedComplexity = Complexity.simple;
  var _selectedImageUrl = "";
  int _selectedDuration = 0;

  var _isGlutenfree = false;
  var _isLactosefree = false;
  var _isVegan = false;
  var _isVegeterian = false;

  final _formKey = GlobalKey<FormState>();

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void _openAddIngredientsOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddIngredients(
              saveIngredients: _addIngredients,
            ));
  }

  void _openAddStepsOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddSteps(saveSteps: _addSteps),
    );
  }

  void _addIngredients(List<String> ingredientsList) {
    for (final ingredient in ingredientsList) {
      _listOfIngredients.add(ingredient);
    }
  }

  void _addSteps(List<String> stepsList) {
    for (final step in stepsList) {
      _listOfSteps.add(step);
    }
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: ((context) => CupertinoAlertDialog(
              title: const Text('Invalid input'),
              content: const Text('You nust add ingredients and steps'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'))
              ],
            )),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('You must add ingredients and steps'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'))
          ],
        ),
      );
    }
  }

  void _createMeal() {
    if (_listOfIngredients.isEmpty && _listOfSteps.isEmpty) {
      _showDialog();
    } else {}
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _selectedCategoryList.add(_selectedCategory.id);
      _addMeal();
    }
  }

  void _addMeal() {
    final Meal meal = Meal(
      id: getRandomString(10),
      categories: _selectedCategoryList,
      title: _selectedTitle,
      imageUrl: _selectedImageUrl,
      ingredients: _listOfIngredients,
      steps: _listOfSteps,
      duration: _selectedDuration,
      complexity: _selectedComplexity,
      affordability: _selectedAffordability,
      isGlutenFree: _isGlutenfree,
      isLactoseFree: _isLactosefree,
      isVegan: _isVegan,
      isVegetarian: _isVegeterian,
    );
    //FIX GLUTEN VEGAN OSV

    widget.availableMeals.add(meal);
    print(meal);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add a new meal to the collection of meals.',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 50,
                      decoration: InputDecoration(
                          label: Text(
                        'Title',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                            ),
                      )),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Wrong input';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedTitle = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              //CATEGORY ROW
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Category:',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                          ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final Category category in availableCategories)
                          DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Text(
                                  category.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                )
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              // AFFORDABILITY ROW
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Affordability:',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                          ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedAffordability,
                      items: [
                        for (final affordability in Affordability.values)
                          DropdownMenuItem(
                            value: affordability,
                            child: Row(
                              children: [
                                Text(
                                  affordability.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                )
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAffordability = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              //COMPLEXITY ROW
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Complexity:',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                          ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedComplexity,
                      items: [
                        for (final complexity in Complexity.values)
                          DropdownMenuItem(
                            value: complexity,
                            child: Row(
                              children: [
                                Text(
                                  complexity.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                )
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedComplexity = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              //IMAGE ROW
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 100,
                      decoration: InputDecoration(
                          label: Text(
                        'Image URL',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                            ),
                      )),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 10) {
                          return 'Wrong input';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _selectedImageUrl = value;
                      },
                    ),
                  ),
                ],
              ),
              //DURATION ROW
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 100,
                      decoration: InputDecoration(
                        label: Text(
                          'Duration (min)',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 16,
                              ),
                        ),
                      ),
                      validator: (value) {
                        if (int.tryParse(value!) != null) {
                          return null;
                        } else {
                          return 'You must enter a number';
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedDuration = int.parse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Check off what best describes the meal:',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      value: _isGlutenfree,
                      onChanged: (bool? isChecked) {
                        setState(() {
                          _isGlutenfree = isChecked ?? false;
                        });
                      },
                      title: const Text('Glutenfree'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      value: _isLactosefree,
                      onChanged: (bool? isChecked) {
                        setState(() {
                          _isLactosefree = isChecked ?? false;
                        });
                      },
                      title: const Text('Lactosefree'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      value: _isVegeterian,
                      onChanged: (bool? isChecked) {
                        setState(() {
                          _isVegeterian = isChecked ?? false;
                        });
                      },
                      title: const Text('Vegeterian'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      value: _isVegan,
                      onChanged: (bool? isChecked) {
                        setState(() {
                          _isVegan = isChecked ?? false;
                        });
                      },
                      title: const Text('Vegan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //INGREDIENTS AND STEPS ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      child: const Text('Add Ingredients'),
                      onPressed: () {
                        _openAddIngredientsOverlay();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      child: const Text('Add Steps'),
                      onPressed: () {
                        _openAddStepsOverlay();
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(top: 20, bottom: 20)),
                      onPressed: () {
                        _createMeal();
                      },
                      child: const Text('Add Meal'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
