
import 'package:flutter/material.dart';
import 'package:nutrition_app/dashboard.dart';
import 'package:nutrition_app/ocr.dart';
final AssetImage customBrainIcon = AssetImage('assets/brain_icon.png');
class taskbar extends StatelessWidget {
  const taskbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
      color: Color(0xFF223D60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()), // Navigate to the AboutPage
              );
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
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OCR()), // Navigate to the AboutPage
              );
            },
          ),
        ],
      ),
    );
  }
}

