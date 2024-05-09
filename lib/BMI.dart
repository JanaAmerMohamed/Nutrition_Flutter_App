
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_app/BMI_history.dart';

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Text(
                "BMI Calculator",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),

        backgroundColor: Color(0xFF223D60),
      ),
      body: BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double _height = 170.0;
  double _weight = 70.0;
  int _age = 30;
  String _gender = 'Male';
  double _bmi = 0.0;
  String _bmiCategory = '';

  void _calculateBMI() async {
    final uid = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID

    // Create a reference to the user's patient document
    final patientRef = FirebaseFirestore.instance.collection('patients').doc(uid);

    // Get the current date and time
    DateTime now = DateTime.now();

    setState(() {
      _bmi = _weight / pow(_height / 100, 2);
      if (_bmi < 18.5) {
        _bmiCategory = 'Underweight';
      } else if (_bmi >= 18.5 && _bmi < 25) {
        _bmiCategory = 'Normal';
      } else if (_bmi >= 25 && _bmi < 30) {
        _bmiCategory = 'Overweight';
      } else {
        _bmiCategory = 'Obese';
      }
    });

    // Create a new document within the BMI Calculator History collection of the patient
    await patientRef.collection('BMI Calculator History').add({
      'date': Timestamp.fromDate(now),
      'height': _height,
      'weight': _weight,
      'age': _age,
      'gender': _gender,
      'bmi': _bmi,
      'bmiCategory': _bmiCategory,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Height: $_height cm',style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF223D60),fontSize: 17 ),),
            Slider(
              activeColor: Color(0xFF223D60),
              value: _height,
              min: 100.0,
              max: 250.0,
              divisions: 150,
              onChanged: (value) {
                setState(() {
                  _height = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Weight: $_weight kg',style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF223D60),fontSize: 17 ),),
            Slider(
              activeColor: Color(0xFF223D60),
              value: _weight,
              min: 40.0,
              max: 200.0,
              divisions: 160,
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Age: $_age',style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF223D60),fontSize: 17 ),),
            Slider(
              activeColor: Color(0xFF223D60),
              value: _age.toDouble(),
              min: 18.0,
              max: 100.0,
              divisions: 82,
              onChanged: (value) {
                setState(() {
                  _age = value.toInt();
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gender: $_gender',style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF223D60),fontSize: 17 ),),
                DropdownButton<String>(
                  value: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                  items: ['Male', 'Female'].map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender,style: TextStyle(color:Colors.red,fontSize: 17 ),),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF223D60), // Background color

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjust padding as needed
                ),
                onPressed: _calculateBMI,

                child: Text(
                  'Calculate BMI',
                  style: TextStyle(fontSize: 20,color: Colors.white),
                ),
              ),

            ),

            SizedBox(height: 16.0),
            Container(
              width: 500,
              height: 200,
              child: Card(
                elevation: 4.0, // Adjust elevation as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.all(16.0), // Adjust margin as needed
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Adjust padding as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Center(

                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 18.0),
                            children: [
                              TextSpan(
                                text: 'Your BMI: ',
                                style: TextStyle(
                                  color: Color(0xFF223D60), // Color for the label
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _bmi.toStringAsFixed(2), // Value text with two decimal points
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red, // Color for the value
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 18.0),
                            children: [
                              TextSpan(
                                text: 'BMI Category: ',
                                style: TextStyle(
                                  color: Color(0xFF223D60), // Color for the label
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '$_bmiCategory', // Value text
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red, // Color for the value
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


