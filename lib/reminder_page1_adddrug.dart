
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/entry_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class drug_card extends StatefulWidget {
  const drug_card({super.key});

  @override
  State<drug_card> createState() => _drug_cardState();
}

class _drug_cardState extends State<drug_card> {
  String convertTime(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final format = DateFormat('yyyy-MM-dd hh:mm a'); // Include year, month, day
    return format.format(dateTime);
  }
  Timestamp? formattedTime;

  List<DrugInfo> _drugs = [];
  void initState() {
    super.initState();
    _fetchDrugs(); // Fetch drug data on page load
  }
  Future<void> _fetchDrugs() async {
    final uid = FirebaseAuth.instance.currentUser!.uid; // Get current user ID

    // Create a reference to the drugs collection within the user's patient document
    final drugRef = _firestore.collection('patients').doc(uid).collection('drugs');

    // Stream to listen for changes in the drug collection
    final drugStream = drugRef.snapshots();

    drugStream.listen((snapshot) {
      _drugs = snapshot.docs.map((doc) => DrugInfo.fromSnapshot(doc)).toList();
      formattedTime = Timestamp.fromDate(DateTime.now());  // Assuming _time holds hour and minute
      setState(() {}); // Update UI when drug list changes and formattedTime is available
    });
  }

  Future<void> _deleteDrug(DrugInfo drug) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final drugRef = _firestore.collection('patients').doc(uid).collection('drugs').doc(drug.id);
    await drugRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Text(
            "MY MEDICINES",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: _drugs.isEmpty
          ? Center(
        child: Text(
          "No medicines added yet.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: _drugs.length,
        itemBuilder: (context, index) {
          final drug = _drugs[index];
          return _buildDrugCard(drug); // Build card for each drug
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DataEntry()), // Navigate to data entry page
          );
        },
        backgroundColor: Color(0xFF223D60), // Set the color
        child: Icon(Icons.add, color: Colors.white), // Plus icon
      ),
    );
  }

  Widget _buildDrugCard(DrugInfo drug) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drug.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Dose: ${drug.dose}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        "Type: ${drug.type}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Interval: ${drug.interval} hour(s)",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Time: ${convertTime(drug.time)}", // Use formattedTime! and call convertTime
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                _deleteDrug(drug);
              },
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class DrugInfo {
  final String id;
  final String name;
  final String dose;
  final String type;
  final int interval;
  final Timestamp time;

  DrugInfo({
    required this.id,
    required this.name,
    required this.dose,
    required this.type,
    required this.interval,
    required this.time,
  });

  // Add a factory constructor to create a DrugInfo object from a Firestore document snapshot
  factory DrugInfo.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return DrugInfo(
      id: snapshot.id,
      name: data['name'] as String,
      dose: data['dose'] as String,
      type: data['type'] as String,
      interval: data['interval'] as int,
      time: data['time'] as Timestamp,
    );
  }
}



