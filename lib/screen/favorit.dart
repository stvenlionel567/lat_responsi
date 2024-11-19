import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'meal_model.dart';

class FavoritePage extends StatelessWidget {
  void favorite() async {
    await Hive.initFlutter();
    await Hive.openBox('favoriteMeals'); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorit Makanan')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favoriteMeals')
            .listenable(), // Accessing the box after it's opened
        builder: (context, Box box, _) {
          final meals = box.values.toList().cast<Meal>();

          return meals.isEmpty
              ? Center(child: Text('Belum ada favorit'))
              : ListView.builder(
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(meal.strMealThumb + '/preview'),
                        title: Text(meal.strMeal),
                        subtitle: Text('${meal.strCategory} | ${meal.strArea}'),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
