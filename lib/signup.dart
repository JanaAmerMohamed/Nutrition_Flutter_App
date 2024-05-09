import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/confirm.dart';
import 'package:nutrition_app/loginpage.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isPasswordVisible = false;
  bool _isPasswordWeak = false;
  bool _isPhoneNumberValid = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();

  late String generatedId; // Declare generatedId here

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    super.dispose();
  }

  bool isPasswordCompliant(String password) {
    // Password validation using regex
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  bool isPhoneNumberValid(String value) {
    // Phone number validation - must be exactly 10 digits
    String pattern = r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  String generateRandomID(String lastFourDigits) {
    Random random = Random();
    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    StringBuffer sb = StringBuffer();

    sb.write(lastFourDigits);

    for (int i = 0; i < 6; i++) {
      sb.write(characters[random.nextInt(characters.length)]);
    }

    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Text(
            "REGISTER",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                "Create Your Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF223D60)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your Username!',
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your Email!',
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    _isPasswordWeak = !isPasswordCompliant(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Password!',
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            if (_isPasswordWeak)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Password must be at least 8 characters long and include letters and numbers.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter your Phone!',
                  prefixText: '+20 ',
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  errorText: _isPhoneNumberValid ? null : 'Invalid phone number',
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (value) {
                  if (value.length > 10) {
                    setState(() {
                      phoneController.text = value.substring(0, 10);
                    });
                  }
                  setState(() {
                    _isPhoneNumberValid = isPhoneNumberValid(phoneController.text);
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: nationalIdController,
                decoration: InputDecoration(
                  hintText: 'Enter your National ID!',
                  prefixIcon: Icon(Icons.badge),
                  labelText: 'National ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF223D60),
    shape: StadiumBorder(),
    ),
                  onPressed: () async {
                    if (_isPasswordWeak || !_isPhoneNumberValid) {
                      return;
                    }
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      String uid = userCredential.user!.uid;

                      generatedId = generateRandomID(nationalIdController.text.substring(nationalIdController.text.length - 4));

                      await FirebaseFirestore.instance.collection('patients').doc(uid).set({
                        'userType': 'patient',
                        'username': usernameController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'password': passwordController.text,
                        'nationalId': nationalIdController.text,
                        'generatedId': generatedId,
                      });

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => confirm(flutterLocalNotificationsPlugin: widget.)),
                      // );

                      Fluttertoast.showToast(
                        msg: 'Successfully signed up. Your ID: $generatedId',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                    } catch (e) {
                      print(e);
                      if (e.toString().contains('account already exists')) {
                        showExistingAccountAlert(context);
                      }
                    }
                  },
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 70),
              child: Row(
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Sign In   ',
                      style: TextStyle(
                        color: Color(0xFFb08e6b),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showExistingAccountAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Account Already Exists'),
        content: Text('The provided email or phone number is already registered.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
