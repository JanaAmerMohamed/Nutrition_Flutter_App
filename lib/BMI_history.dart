import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class BMICard extends StatefulWidget {
  const BMICard({Key? key}) : super(key: key);

  @override
  State<BMICard> createState() => _BMICardState();
}

class _BMICardState extends State<BMICard> {
  List<BMIData> _bmiData = [];

  void initState() {
    super.initState();
    _fetchBMI(); // Fetch BMI data on page load
  }

  Future<void> _fetchBMI() async {
    final uid = FirebaseAuth.instance.currentUser!.uid; // Get current user ID

    // Create a reference to the BMI Calculator History collection within the user's patient document
    final bmiRef = _firestore.collection('patients').doc(uid).collection('BMI Calculator History');

    // Stream to listen for changes in the BMI collection
    final bmiStream = bmiRef.snapshots();

    bmiStream.listen((snapshot) {
      _bmiData = snapshot.docs.map((doc) => BMIData.fromSnapshot(doc)).toList();
      setState(() {}); // Update UI when BMI data changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
        appBar: AppBar(

          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Text(
                  "BMI History",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),

          backgroundColor: Color(0xFF223D60),
        ),
        body: _bmiData.isEmpty
          ? Center(
        child: Text(
          "No BMI data available.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
            )
          : ListView.builder(
        itemCount: _bmiData.length,
        itemBuilder: (context, index) {
          final bmiEntry = _bmiData[index];
          return _buildBMICard(bmiEntry); // Build card for each BMI entry
        },
            ),
      );
  }

  Widget _buildBMICard(BMIData bmiEntry) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${convertTimestamp(bmiEntry.date)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),
            Text(
              'BMI: ${bmiEntry.bmi.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'BMI Category: ${bmiEntry.bmiCategory}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String convertTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final format = DateFormat('yyyy-MM-dd'); // Customize date format as needed
    return format.format(dateTime);
  }
}

class BMIData {
  final Timestamp date;
  final double height;
  final double weight;
  final int age;
  final String gender;
  final double bmi;
  final String bmiCategory;

  BMIData({
    required this.date,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.bmi,
    required this.bmiCategory,
  });

  // Factory constructor to create a BMIData object from a Firestore document snapshot
  factory BMIData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BMIData(
      date: data['date'] as Timestamp,
      height: data['height'] as double,
      weight: data['weight'] as double,
      age: data['age'] as int,
      gender: data['gender'] as String,
      bmi: data['bmi'] as double,
      bmiCategory: data['bmiCategory'] as String,
    );
  }
}

