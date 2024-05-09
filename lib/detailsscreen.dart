import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:nutrition_app/models/foodmodel.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  DetailScreen(this.id);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  FoodData? fooddata;
  bool loading = true;
  List<String> allergies = []; // List to store allergies fetched from Firebase

  @override
  void initState() {
    fetchData();
    fetchAllergies(); // Fetch allergies from Firebase
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${fooddata?.description ?? ""}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF223D60),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Portion: per 100g",
                style: TextStyle(
                  color: Color(0xFF223D60),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: fooddata == null ? 0 : fooddata?.foodNutrients.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${fooddata?.foodNutrients[index].nutrient.name}:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${fooddata?.foodNutrients[index].amount}  ${fooddata?.foodNutrients[index].amount == null ? "" : fooddata?.foodNutrients[index].nutrient.unitName}",
                                  style: TextStyle(color: Color(0xFF223D60), fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    var url = Uri.parse("https://api.nal.usda.gov/fdc/v1/food/${widget.id}?api_key=DEMO_KEY");
    var response = await http.get(url);
    var decode = convert.jsonDecode(response.body);
    setState(() {
      fooddata = FoodData.fromMap(decode);
      loading = false;
      checkAllergies(); // Call the function to check for allergies
    });
  }

  Future<void> fetchAllergies() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid != null) {
      final allergyCollection = FirebaseFirestore.instance.collection('patients').doc(uid).collection('allergy');
      var snapshot = await allergyCollection.get();
      setState(() {
        allergies = snapshot.docs.map((doc) => doc['allergyName'].toString()).toList();
      });
    }
  }

  void checkAllergies() {
    if (fooddata != null && fooddata!.foodNutrients.isNotEmpty) {
      for (var allergy in allergies) {
        for (var nutrient in fooddata!.foodNutrients) {
          if (nutrient.nutrient.name == allergy && nutrient.amount != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Warning"),
                  content: Text("Don't take it! Contains $allergy"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
            break; // Stop searching after finding an allergy
          }
        }
      }
    }
  }
}
