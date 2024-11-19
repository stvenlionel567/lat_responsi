import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lat_responsi/screen/favorit.dart';
import 'package:lat_responsi/screen/login.dart';
import 'package:lat_responsi/screen/meal_model.dart';
import 'package:lat_responsi/screen/menu_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('favoriteMeals'); // Open box for storing favorite meals
  runApp(Homepage());
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferences logindata;
  late String username;
  late List<Meal> meals; // Declare meals to store the list of meals from API

  @override
  void initState() {
    super.initState();
    initial();
    meals = []; // Initialize the meals list
    fetchMeals(); // Fetch meals from API
  }

  // Function to initialize shared preferences and fetch the username
  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? 'Guest';
    });
  }

  // Function to fetch meals from API
  Future<void> fetchMeals() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=a'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> mealList = data['meals'] ?? [];
      setState(() {
        meals = mealList.map((meal) => Meal.fromJson(meal)).toList();
      });
    } else {
      throw Exception('Failed to load meals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Makanan'),
        actions: [
          // Button to go to the Favorite Page
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display username from shared preferences
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Selamat Datang, $username"),
          ),
          ElevatedButton(
            onPressed: () {
              logindata.setBool('login', true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Logout'),
          ),
          Expanded(
            child: meals.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show loading spinner if no meals
                : ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return Card(
                        child: ListTile(
                          leading:
                              Image.network(meal.strMealThumb + '/preview'),
                          title: Text(meal.strMeal),
                          subtitle:
                              Text('${meal.strCategory} | ${meal.strArea}'),
                          onTap: () {
                            // Navigate to detail page when the card is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MealDetailPage(meal: meal),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {
                              // Add meal to favorites using Hive
                              var box = Hive.box('favoriteMeals');
                              box.add(meal);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
