import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/filters_provider.dart';
import 'package:meals/screens/addMeal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/favorites_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  //Figures out which page to show based on the index from bottomNavigationBar
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Executed if one of ListTiles in MainDrawer is pressed
  void _setScreen(String identifier) async {
    //async to use future returned
    Navigator.pop(context); //Closes the MainDrawers
    if (identifier == 'filters') {
      //Navigates to the FiltersScreen
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        //Values returned from filters screen are saved in result.
        //Tells what will be retruned with push<returntype>
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Adds listener which re-executes the build method whenever the data there changes
    // Watch also returns the data of the provider it watches
    final theAvailableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: theAvailableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoritesProvider);
      activePageTitle = ' Your Favorites';
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
    }

    if (_selectedPageIndex == 2) {
      //Make sure new page is loaded here
      activePageTitle = 'Add meal';
      setState(() {
        activePage = AddMealScreen(
          availableMeals: theAvailableMeals,
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ), //This is the drawe/menu that comes out from the side
      body: activePage, //The page which is shown based on the bottomnavigator
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedPageIndex, //Makes sure that the button of current screen is higlighted
        onTap: _selectPage, // Selects page based on which button is pressed
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add meal',
          ),
        ],
      ),
    );
  }
}
