import 'package:flutter/material.dart';
import 'package:nutrition_app/card_widget.dart';
import 'package:nutrition_app/detailsscreen.dart';
import 'package:nutrition_app/fruitscategories.dart'; // Import the fruits page widget
import 'package:nutrition_app/models/foodmodel.dart';
import 'package:nutrition_app/searchfood.dart';
import 'package:nutrition_app/taskbar.dart';
import 'package:nutrition_app/vegcategories.dart';



class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Text(
              "Food Calories",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search), // Add the search icon here
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreensearch()), // Replace FruitsPage with the actual fruits page widget
                );
              },
            ),
          ],
          backgroundColor: Color(0xFF223D60),
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF223D60),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to the fruits page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => fruits()), // Replace FruitsPage with the actual fruits page widget
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 190,
                    child: CardWidget(
                      imagePath: "lib/image/fruits.jpg",
                      foodName: "Fruits",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => fruits()), // Navigate to fruits page
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to the fruits page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => vegtables()), // Replace FruitsPage with the actual fruits page widget
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 190,
                    child: CardWidget(
                      imagePath: "lib/image/65d826558a35f (1).png",
                      foodName: "Vegtables",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => vegtables()), // Navigate to fruits page
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 200, top: 20, bottom: 30, left: 20),
            child: Text(
              "Most Demand",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF223D60),
              ),
            ),
          ),
          Container(
            height: 185,
            width: 500,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 10),
                  CardWidget(
                    imagePath: "lib/image/mango.jpg",
                    foodName: "Mango",
                    onPressed: () => _navigateToDetail(context, 1102670),
                  ),
                  CardWidget(
                    imagePath: "lib/image/Peanut.jpg",
                    foodName: "Peanut",
                    onPressed: () => _navigateToDetail(context, 1100534),
                  ),
                  CardWidget(
                    imagePath: "lib/image/orange.jpg",
                    foodName: "Orange",
                    onPressed: () => _navigateToDetail(context, 1102597),
                  ),
                  CardWidget(
                    imagePath: "lib/image/banana.jpg",
                    foodName: "Banana",
                    onPressed: () => _navigateToDetail(context, 1102653),
                  ),
                  CardWidget(
                    imagePath: "lib/image/okra.jpg",
                    foodName: "Okra",
                    onPressed: () => _navigateToDetail(context, 1103528),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: taskbar(),
    );
  }

  void _navigateToDetail(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(id)),
    );
  }
}
