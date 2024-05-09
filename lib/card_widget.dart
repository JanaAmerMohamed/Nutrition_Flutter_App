import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imagePath;
  final String foodName;
  final VoidCallback onPressed;

  const CardWidget({
    required this.imagePath,
    required this.foodName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200, // Set a fixed width for the card
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover, // Ensure the image covers the entire space without distortion
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                foodName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF223D60)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
