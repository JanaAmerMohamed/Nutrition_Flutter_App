import 'package:flutter/material.dart';
import 'package:nutrition_app/taskbar.dart';

import 'card_widget.dart';
import 'detailsscreen.dart';

class vegtables extends StatelessWidget {
  const vegtables({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            "Vegtables Categories",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 30),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 200, // Adjust height as needed
                    width: 200, // Adjust width as needed
                    child: CardWidget(
                      imagePath: "lib/image/beans.jpg",
                      foodName: "Green beans",
                      onPressed: () => _navigateToDetail(context, 75101800),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between cards
                  SizedBox(
                    height: 200, // Adjust height as needed
                    width: 200,
                    child: CardWidget(
                      imagePath: "lib/image/Tomato-Iran.jpg",
                      foodName: "Tomatoes",
                      onPressed: () => _navigateToDetail(context, 74101000),
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
                    height: 200, // Adjust height as needed
                    width: 200,
                    child: CardWidget(
                      imagePath: "lib/image/concombre.jpg",
                      foodName: "Cucumber",
                      onPressed: () => _navigateToDetail(context, 75111000),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between cards
                  SizedBox(
                    height: 200, // Adjust height as needed
                    width: 200,
                    child: CardWidget(
                      imagePath: "lib/image/okra.jpg",
                      foodName: "Okra",
                      onPressed: () => _navigateToDetail(context, 1103528),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
