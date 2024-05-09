import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAllergy extends StatelessWidget {
  const AddAllergy({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    TextEditingController allergyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Upload papers for Medications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            child: Text(
              "Mind your allergies! Only add ingredients you're sure are safe for you. Stay healthy!",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF223D60)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: TextField(
              controller: allergyController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter the allergy',
                prefixIcon: Icon(Icons.description),
                labelText: 'Enter an allergy substance that you face in food',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF223D60),
              shape: StadiumBorder(),
            ),
            onPressed: () {
              if (uid != null) {
                final pdfCollection = FirebaseFirestore.instance.collection('patients').doc(uid).collection('allergy');
                pdfCollection.add({
                  'allergyName': allergyController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Allergy added successfully')),
                  );
                  allergyController.clear(); // Clear the TextField after successful addition
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add allergy: $error')),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User not logged in')),
                );
              }
            },
            child: const Text('Add Allergy', style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
