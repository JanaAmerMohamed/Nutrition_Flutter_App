import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_app/BMI.dart';
import 'package:nutrition_app/BMI_history.dart';
import 'package:nutrition_app/Gemini/homepage.dart';
import 'package:nutrition_app/addallergy.dart';
import 'package:nutrition_app/card.dart';
import 'package:nutrition_app/detailsscreen.dart';
import 'package:nutrition_app/entry_data.dart';
import 'package:nutrition_app/fruitscategories.dart';
import 'package:nutrition_app/ocr.dart';
import 'package:nutrition_app/pdf.dart';
import 'package:nutrition_app/reminder_page1_adddrug.dart';
import 'package:nutrition_app/taskbar.dart'; // Import your taskbar widget here
import 'package:fl_chart/fl_chart.dart';
import 'package:nutrition_app/videocall/index.dart';

final AssetImage customBrainIcon = AssetImage('lib/image/4497578.webp');
final AssetImage customBrainIcon2 = AssetImage('lib/image/shutterstock_1867675627-scaled.jpg');
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String patientName = '';
  late String generatedId = '';
  late String userEmail = '';
  late String nationalId = '';
  late String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    // Get the current user ID
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Fetch the document from Firestore using the user ID
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('patients').doc(uid).get();

      // Get the 'username', 'generatedId', 'email', 'nationalId', and 'phoneNumber' fields from the document
      if (snapshot.exists) {
        setState(() {
          patientName = snapshot.data()?['username'] ?? '';
          generatedId = snapshot.data()?['generatedId'] ?? '';
          userEmail = snapshot.data()?['email'] ?? '';
          nationalId = snapshot.data()?['nationalId'] ?? '';
          phoneNumber = snapshot.data()?['phone'] ?? '';
        });
      }
    }
    setState(() {}); // Force a rebuild after data fetching is complete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            "Dashboard      ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.person, size: 50, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Welcome, $patientName",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF223D60)),
                ),
                SizedBox(width: 80),
                IconButton(
                  icon: Tooltip(
                    message: 'add allergy',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_food, color: Colors.deepOrangeAccent),
                        Text('add allergy', style: TextStyle(color: Colors.deepOrangeAccent)),
                      ],
                    ),
                  ),
                  iconSize: 30,
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAllergy()),
                    );
                  }
                ),

              ],
            ),
          ),
          Container(
            height: 140,
            width: 400,
            color: Color(0xFF223D60),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Medical ID : ',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: generatedId,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Email : ',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: userEmail,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'National ID : ',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: nationalId,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Phone : ',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: phoneNumber,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 230, top: 50, bottom: 30, left: 20),
            child: Text(
              "Most Demand",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF223D60),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  // Add functionality for settings icon
                },
                icon: Container(
                  width: 80, // Set the desired width
                  height: 80, // Set the desired height
                  child: Image(image: customBrainIcon), // Use the custom brain icon
                ),
              ),

              IconButton(
                icon: Icon(Icons.notification_add, color: Colors.blue),
                iconSize: 70,
                onPressed: () => _navigateTodataentry(context),
              ),
              IconButton(
                icon: Icon(Icons.calculate_sharp, color: Colors.orange),
                iconSize: 70,
                onPressed: () => _navigateToBMI2(context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.fastfood, color: Colors.deepOrangeAccent),
                iconSize: 70,
                onPressed: () => _navigateTofruits(context),
              ),
              IconButton(
                icon: Icon(Icons.history_edu_outlined, color: Colors.red),
                iconSize: 70,
                onPressed: () => _navigateToBMI(context),
              ),
              IconButton(
                icon: Icon(Icons.list_alt_rounded, color: Color(0xFF223D60)),
                iconSize: 70,
                onPressed: () => _navigateTodrug(context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                iconSize: 70,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPlus()),
                  );
                  // Add functionality for settings icon
                },
              ),
              IconButton(
                icon: Icon(Icons.video_call, color: Color(0xFF223D60)),
                iconSize: 70,
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp2()),
                  );
                },
              ),
              IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OCR()),
                  );
                  // Add functionality for settings icon
                },
                icon: Container(
                  width: 80, // Set the desired width
                  height: 80, // Set the desired height
                  child: Image(image: customBrainIcon2), // Use the custom brain icon
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: taskbar(), // Add your taskbar widget here in the bottomNavigationBar property
    );
  }

  void _navigateToOCR(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OCR()),
    );
  }

  void _navigateTodrug(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => drug_card()),
    );
  }

  void _navigateToBMI(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BMICard()),
    );
  }

  void _navigateTofruits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardPage()),
    );
  }

  void _navigateToBMI2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BMICalculatorApp()),
    );
  }

  void _navigateTodataentry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DataEntry()),
    );
  }
}
