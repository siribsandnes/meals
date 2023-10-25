import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = {
  //k is flutterconvention for global values
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegeterian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selctedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

//Function for adding or removing a favorite meal.
  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisitng = _favoriteMeals
        .contains(meal); //Checks if the list contains the specific meal

    //If the meal allready is in the list it is removed. If it is not in the list it is added to the list.
    if (isExisitng) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal was removed from fvorites');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage("Meal was added to favorites");
      });
    }
  }

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
          builder: (ctx) => FiltersScreen(
            currentFilters: _selctedFilters,
          ),
        ),
      );
      setState(() {
        _selctedFilters = result ??
            _selctedFilters; //?? checks if value in front is null. if it is the value behind ?? is the fallback value
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theAvailableMeals = dummyMeals.where((meal) {
      if (_selctedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selctedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selctedFilters[Filter.vegeterian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selctedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: theAvailableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePageTitle = ' Your Favorites';
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
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
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
