import 'package:flutter/material.dart';
import 'package:nutrition_app/card.dart';
import 'package:nutrition_app/foodapi.dart';
import 'package:nutrition_app/loginpage.dart';
import 'package:nutrition_app/ocr.dart';
import 'package:nutrition_app/reminder_page1_adddrug.dart';
import 'package:nutrition_app/signup.dart';

class intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScrollablePages(),
    );
  }
}

class ScrollablePages extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageOne(),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage('lib/image/Premium Photo _ 3d illustration of a cartoon character with a mask for coronavirus prevention.jpg'),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 30,bottom: 10,),
            child: Text("Complete Health Solutions", style: TextStyle(color: Color(0xFF223D60), fontSize: 25, fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 120,),
            child: Text("Early Protection & Save your Health !", style: TextStyle(color: Color(0xFF223D60), fontSize: 15),),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF223D60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the AboutPage
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "         Get Started         ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}







