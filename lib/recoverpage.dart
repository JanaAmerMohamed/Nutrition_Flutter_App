import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'messageupdatepassword.dart';

class recover extends StatefulWidget {
  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<recover> {
  final TextEditingController emailController = TextEditingController();
  String errorMessage = '';
  bool emailExists = false; // Added boolean variable to track email existence

  Future<void> updateUserAfterPasswordReset(String email, BuildContext context) async {
    final CollectionReference sellersCollection = FirebaseFirestore.instance.collection('sellers');
    final CollectionReference customerCollection = FirebaseFirestore.instance.collection('Customer');

    final QuerySnapshot sellersSnapshot = await sellersCollection.where('email', isEqualTo: email).get();
    final QuerySnapshot customerSnapshot = await customerCollection.where('email', isEqualTo: email).get();

    if (sellersSnapshot.docs.isNotEmpty) {
      final String userId = sellersSnapshot.docs.first.id;
      await sellersCollection.doc(userId).update({
        'passwordReset': true,
      });
      setState(() {
        emailExists = true; // Set emailExists to true if email exists
      });
    } else if (customerSnapshot.docs.isNotEmpty) {
      final String userId = customerSnapshot.docs.first.id;
      await customerCollection.doc(userId).update({
        'passwordReset': true,
      });
      setState(() {
        emailExists = true; // Set emailExists to true if email exists
      });
    } else {
      setState(() {
        errorMessage = 'Email does not exist';
      });
    }

    if (emailExists) {
      // Email exists, send reset email and navigate to LoadingPage5
      await sendPasswordResetEmail(email, context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingPage5()),
      );
    }
  }



  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error sending reset email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                "RECOVER-PASSWORD",
                style: TextStyle(color: Colors.white),
              ),
            ),

          ],
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50,left: 40),
              child: Text(
                "Forget Your Password ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Color(0xFF223D60)),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 8, top: 30),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            errorMessage.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 20.0),
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Color(0xff464545),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : SizedBox.shrink(), // To maintain layout spacing when errorMessage is empty
            SizedBox(height: 380),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                await updateUserAfterPasswordReset(email, context);
              },
              child: Text(
                'RESET MY PASSWORD',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF223D60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




