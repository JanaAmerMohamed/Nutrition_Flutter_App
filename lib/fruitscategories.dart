import 'package:flutter/material.dart';
import 'package:nutrition_app/card_widget.dart';
import 'package:nutrition_app/detailsscreen.dart';

class fruits extends StatelessWidget {
  const fruits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            "Fruits Categories",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150, // Adjust width as needed
                    child: CardWidget(
                      imagePath: "lib/image/mango.jpg",
                      foodName: "Mango",
                      onPressed: () => _navigateToDetail(context, 1102670),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between cards
                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150,
                    child: CardWidget(
                      imagePath: "lib/image/orange.jpg",
                      foodName: "Orange",
                      onPressed: () => _navigateToDetail(context, 1102597),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Add spacing between rows
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150,
                    child: CardWidget(
                      imagePath: "lib/image/banana.jpg",
                      foodName: "Banana",
                      onPressed: () => _navigateToDetail(context, 1102653),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between cards
                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150,
                    child: CardWidget(
                      imagePath: "lib/image/okra.jpg",
                      foodName: "Okra",
                      onPressed: () => _navigateToDetail(context, 1103528),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 10), // Add spacing between rows
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[

                  SizedBox(width: 10), // Add spacing between cards

                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150,
                    child: CardWidget(
                      imagePath: "lib/image/Peanut.jpg",
                      foodName: "Peanut",
                      onPressed: () => _navigateToDetail(context, 1100534),
                    ),
                  ),
                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150,
                    child: CardWidget(
                      imagePath: "lib/image/apple.jpg",
                      foodName: "Apple",
                      onPressed: () => _navigateToDetail(context, 1102644),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 10), // Add spacing between rows
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150,
                    child: CardWidget(
                      imagePath: "lib/image/blueberries.jpg",
                      foodName: "Blueberries",
                      onPressed: () => _navigateToDetail(context, 1102702),
                    ),
                  ),
                  SizedBox(
                    height: 150, // Adjust height as needed
                    width: 150,
                    child: CardWidget(
                      imagePath: "lib/image/Peanut.jpg",
                      foodName: "Peanut",
                      onPressed: () => _navigateToDetail(context, 1100534),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF223D60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.home),
              onPressed: () {
                // Add functionality for home icon
              },
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.search),
              onPressed: () {
                // Add functionality for search icon
              },
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add functionality for notifications icon
              },
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.settings),
              onPressed: () {
                // Add functionality for settings icon
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(id)),
    );
  }
}
