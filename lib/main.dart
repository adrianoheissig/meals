import 'package:flutter/material.dart';
import 'package:meals/models/setting.dart';
import 'package:meals/screens/catergories_meals_screen.dart';
import 'package:meals/screens/meal_detail_screen.dart';
import 'package:meals/screens/settings_screen.dart';
import 'package:meals/screens/tabs_screen.dart';

import 'package:meals/utils/app_routes.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/data/dummy_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Setting setting = Setting();
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _filtersMeals(Setting setting) {
    setState(() {
      this.setting = setting;
      _availableMeals = DUMMY_MEALS.where((meal) {
        final filterGluten = setting.isGlutenFree && !meal.isGlutenFree;
        final filterLactose = setting.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = setting.isVegan && !meal.isVegan;
        final filterVegetarian = setting.isVegetarian && !meal.isVegetarian;
        return !filterGluten &&
            !filterLactose &&
            !filterVegan &&
            !filterVegetarian;
      }).toList();
    });
  }

  void _toggleFavoriteMeal(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavoriteMeal(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vamos Cozinhar?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
        ).copyWith(secondary: Colors.amber),
        fontFamily: 'Raleway',
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
              fontFamily: 'RobotoCondensed',
              fontSize: 20,
            )),
      ),
      // home: const CategoriesScreen(),
      initialRoute: AppRoutes.HOME,
      routes: {
        AppRoutes.HOME: (ctx) => TabsScreen(_favoriteMeals),
        AppRoutes.CATEGORIES_MEALS: (ctx) =>
            CategoriesMealsScreen(meals: _availableMeals),
        AppRoutes.MEAL_DETAIL: (ctx) =>
            MealDetailScreen(_toggleFavoriteMeal, _isFavoriteMeal),
        AppRoutes.SETTINGS: (ctx) => SettingsScreen(
              setting: setting,
              onSettingChange: _filtersMeals,
            ),
      },
    );
  }
}
