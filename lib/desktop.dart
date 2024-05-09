import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodCalorieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Calorie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FoodCalorieScreen(),
    );
  }
}



class FoodCalorieScreen extends StatefulWidget {
  @override
  _FoodCalorieScreenState createState() => _FoodCalorieScreenState();
}


class _MealData {
  TextEditingController controller = TextEditingController();
  List<String> caloriesList = []; // Store calories as a list of strings
  bool isExpanded = false;
  int additionalFieldsCount = 0; // Track the number of additional fields
  List<String> foodNames = []; // Store food names for main meal and additional items
  List<TextEditingController> additionalControllers = []; // Store controllers for additional fields
}

class _FoodCalorieScreenState extends State<FoodCalorieScreen> {
  Map<String, _MealData?> mealDataMap = {
    'Breakfast': _MealData(),
    'Lunch': _MealData(),
    'Dinner': _MealData(),
    'Snacks': _MealData(),
  };



  void fetchData(String apiKey, String foodQuery, String mealCategory) async {
    String apiUrl =
        'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=$apiKey&query=$foodQuery&pageSize=1';

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['foods'] != null && data['foods'].length > 0) {
        var foodItem = data['foods'][0];
        var energy = foodItem['foodNutrients']
            .firstWhere((nutrient) => nutrient['nutrientName'] == 'Energy')['value'];
        setState(() {
          mealDataMap[mealCategory]?.foodNames.add(foodItem['description']);
          mealDataMap[mealCategory]?.caloriesList.add('Energy: $energy kcal'); // Append to caloriesList
        });
      } else {
        setState(() {
          mealDataMap[mealCategory]?.caloriesList.add('Food not found'); // Append error message
        });
      }
    } else {
      setState(() {
        mealDataMap[mealCategory]?.caloriesList.add('Error fetching data'); // Append error message
      });
    }
  }

  _MealData? getMealData(String mealCategory) {
    return mealDataMap[mealCategory];
  }

  Widget buildMealContainer(String mealCategory) {
    _MealData? mealData = getMealData(mealCategory);
    if (mealData == null) return SizedBox(); // Return an empty widget if mealData is null

    List<Widget> fields = [];

    // Add text field and button for the main field
    fields.add(
      Column(
        children: [
          TextField(
            controller: mealData.controller,
            decoration: InputDecoration(labelText: 'Enter food item'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              String foodQuery = mealData.controller.text.trim();
              fetchData('DEMO_KEY', foodQuery, mealCategory);
            },
            child: Text('Get Calories'),
          ),
          SizedBox(height: 16.0),
          for (int i = 0; i < mealData.foodNames.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food Name ${i + 1}: ${mealData.foodNames[i]}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  mealData.caloriesList[i],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          SizedBox(height: 16.0),
        ],
      ),
    );

    // Add additional fields and buttons for each additional field
    for (int i = 0; i < mealData.additionalFieldsCount; i++) {
      TextEditingController additionalController;
      if (i < mealData.additionalControllers.length) {
        additionalController = mealData.additionalControllers[i];
      } else {
        additionalController = TextEditingController();
        mealData.additionalControllers.add(additionalController);
      }
      fields.addAll([
        TextField(
          controller: additionalController,
          decoration: InputDecoration(labelText: 'Enter additional food item ${i + 1}'),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            String additionalFoodQuery = additionalController.text.trim();
            fetchData('DEMO_KEY', additionalFoodQuery, mealCategory);
          },
          child: Text('Get Calories for Additional Item ${i + 1}'),
        ),
        SizedBox(height: 16.0),
        for (int j = 0; j < mealData.foodNames.length; j++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Additional Food Name ${j + 1}: ${mealData.foodNames[j]}',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                mealData.caloriesList[j],
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        SizedBox(height: 16.0),
      ]);
    }

    fields.add(
      ElevatedButton(
        onPressed: () {
          setState(() {
            mealData.additionalFieldsCount++; // Increment the count
          });
        },
        child: Text('Add More Fields'),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: fields,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Calorie App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var mealCategory in mealDataMap.keys)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mealCategory,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  setState(() {
                                    mealDataMap[mealCategory]?.isExpanded =
                                    !(mealDataMap[mealCategory]?.isExpanded ?? false);
                                  });
                                },
                              ),
                            ],
                          ),
                          if (mealDataMap[mealCategory]?.isExpanded ?? false)
                            buildMealContainer(mealCategory),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Generate UI for each meal category
                for (var mealCategory in mealDataMap.keys) {
                  setState(() {
                    mealDataMap[mealCategory]?.isExpanded = true;
                  });
                  fetchData('DEMO_KEY', '', mealCategory); // Using the demo key
                }
              },
              child: Text('Generate All Calories'),
            ),
          ],
        ),
      ),
    );
  }
}
















class MyAppplan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Diet Plans'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PlanCard(
                dietCode: "DIET1600",
                meals: [
                  "Scrambled eggs with spinach and whole grain toast (350 calories)",
                  "Greek yogurt with mixed berries and a sprinkle of granola (200 calories)",
                  "Grilled chicken salad with mixed greens, cherry tomatoes, cucumbers, and balsamic vinaigrette (450 calories)",
                  "Apple slices with almond butter (150 calories)",
                  "Baked salmon with quinoa and steamed asparagus (450 calories)"
                ],
                totalCalories: 1600,
                color: Colors.blue,
              ),
              PlanCard(
                dietCode: "DIET1800",
                meals: [
                  "Oatmeal with sliced banana and a drizzle of honey (300 calories)",
                  "Handful of almonds and a piece of fruit (250 calories)",
                  "Turkey and avocado wrap with whole wheat tortilla (500 calories)",
                  "Carrot sticks with hummus (100 calories)",
                  "Stir-fried tofu with mixed vegetables and brown rice (650 calories)"
                ],
                totalCalories: 1800,
                color: Colors.green,
              ),
              PlanCard(
                dietCode: "DIET2000",
                meals: [
                  "Greek yogurt with mixed berries and a sprinkle of chia seeds (300 calories)",
                  "Protein shake with almond milk and banana (250 calories)",
                  "Quinoa salad with chickpeas, cherry tomatoes, feta cheese, and lemon vinaigrette (500 calories)",
                  "Rice cakes with peanut butter (200 calories)",
                  "Grilled steak with sweet potato wedges and roasted Brussels sprouts (750 calories)"
                ],
                totalCalories: 2000,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatefulWidget {
  final String dietCode;
  final List<String> meals;
  final int totalCalories;
  final Color color;

  PlanCard({
    required this.dietCode,
    required this.meals,
    required this.totalCalories,
    required this.color,
  });

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool isExpanded = false;
  List<TextEditingController> mealControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each meal
    for (int i = 0; i < widget.meals.length; i++) {
      mealControllers.add(TextEditingController(text: widget.meals[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Diet Plan: ${widget.dietCode}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded) ...[
            ListTile(
              title: Text(
                'Total Calories: ${widget.totalCalories}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Divider(color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meals:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(widget.meals.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meal ${index + 1}:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: mealControllers[index],
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            onChanged: (newValue) {
                              widget.meals[index] = newValue;
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save button functionality here
                // You can implement the logic to save changes to a database or local storage
                // For demonstration purposes, we print the updated meals list
                for (int i = 0; i < widget.meals.length; i++) {
                  print('Meal ${i + 1}: ${widget.meals[i]}');
                }
              },
              child: Text('Save'),
            ),
          ],
        ],
      ),
    );
  }
}
