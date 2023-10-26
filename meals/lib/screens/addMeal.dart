import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';

//Should implemet adding ned meal here-

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddMealScreenState();
  }
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Form(
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
                      return 'demo'; //FIX LATER
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
                    items: [
                      for (final category in availableCategories)
                        DropdownMenuItem(
                          value: category.id,
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
                    onChanged: (value) {},
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
                    onChanged: (value) {},
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
                    onChanged: (value) {},
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
                      return 'demo'; //FIX LATER
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
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                            ),
                      ),
                    ),
                    validator: (value) {
                      return 'demo'; //FIX LATER
                    },
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
                    child: Text('Add Ingredients'),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    child: Text('Add Steps'),
                    onPressed: () {},
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
                    onPressed: () {},
                    child: const Text('Add Meal'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
