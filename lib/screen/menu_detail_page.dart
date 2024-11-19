import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'meal_model.dart';

class MealDetailPage extends StatelessWidget {
  final Meal meal;

  MealDetailPage({required this.meal});

  @override
  Widget build(BuildContext context) {
    // Split instructions by "\r\n" for bullet points
    final instructions = meal.strInstructions.split('\r\n');

    return Scaffold(
      appBar: AppBar(title: Text(meal.strMeal)),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal.strMealThumb),
            SizedBox(height: 16),
            Text(
              meal.strMeal,
              style: TextStyle(
                fontSize: 24, // Set custom font size
                fontWeight: FontWeight.bold, // Set custom font weight (bold)
              ),
            ),
            SizedBox(height: 8),
            Text('Category: ${meal.strCategory}'),
            Text('Area: ${meal.strArea}'),
            SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 24, // Set custom font size
                fontWeight: FontWeight.bold, // Set custom font weight (bold)
              ),
            ),
            SizedBox(height: 8),
            // Use a ListView.builder if you have a dynamic list of instructions
            ...instructions
                .map((instruction) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text('•',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black)), // Bullet point
                          SizedBox(width: 8),
                          Expanded(child: Text(instruction)),
                        ],
                      ),
                    ))
                .toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                var box = Hive.box('favoriteMeals');
                box.add(meal);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Menu ditambahkan ke favorit'),
                ));
              },
              child: Text('Add to Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
