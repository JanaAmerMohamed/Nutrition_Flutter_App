import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:nutrition_app/models/foodmodel.dart';

class DetailScreensearch extends StatefulWidget {
  @override
  State<DetailScreensearch> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreensearch> {
  FoodData? fooddata;
  bool loading = false;
  TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF223D60),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              focusNode: _searchFocusNode,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter food ID',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _searchFocusNode.requestFocus();
                fetchData();
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            loading
                ? Center(child: CircularProgressIndicator())
                : fooddata == null
                ? Container()
                : Expanded(
              child: ListView.builder(
                itemCount: fooddata!.foodNutrients.length,
                itemBuilder: (context, index) {
                  final nutrient = fooddata!.foodNutrients[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${nutrient.nutrient.name}:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${nutrient.amount ?? ""} ${nutrient.amount == null ? "" : nutrient.nutrient.unitName}",
                                style: TextStyle(
                                  color: Color(0xFF223D60),
                                  fontSize: 15,
                                ),
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
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    String foodId = _searchController.text.trim();
    if (foodId.isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    var url = Uri.parse(
        "https://api.nal.usda.gov/fdc/v1/food/$foodId?api_key=DEMO_KEY");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decode = convert.jsonDecode(response.body);
        if (decode is Map<String, dynamic>) {
          setState(() {
            fooddata = FoodData.fromMap(decode);
            loading = false;
          });
        } else {
          // Handle invalid response format
          setState(() {
            fooddata = null;
            loading = false;
          });
        }
      } else {
        // Handle API error response
        setState(() {
          fooddata = null;
          loading = false;
        });
      }
    } catch (e) {
      // Handle network or other exceptions
      setState(() {
        fooddata = null;
        loading = false;
      });
    }
  }
}