import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/Notifications/splashscreen.dart';
import 'package:nutrition_app/dashboard.dart';
import 'package:nutrition_app/recoverpage.dart';
import 'package:nutrition_app/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userCredential;
  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _saveRememberMeStatus();
        String uid = userCredential.user!.uid;
        String email = userCredential.user!.email ?? '';


        DocumentSnapshot userSnapshotCustomer = await FirebaseFirestore.instance
            .collection('Customer')
            .doc(uid)
            .get();

        DocumentSnapshot userSnapshotSellers = await FirebaseFirestore.instance
            .collection('sellers')
            .doc(uid)
            .get();

        if (userSnapshotCustomer.exists || userSnapshotSellers.exists) {
          String userType =
          userSnapshotCustomer.exists ? 'customer' : 'seller';

        } else {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              String userType = 'customer';
              String name = '';
              String phoneNumber = '+20';

              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: Text('Select Role'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Are you a Seller or a Customer?'),
                      ListTile(
                        title: Text('Seller'),
                        leading: Radio(
                          value: 'seller',
                          groupValue: userType,
                          onChanged: (value) {
                            setState(() {
                              userType = value as String;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Customer'),
                        leading: Radio(
                          value: 'customer',
                          groupValue: userType,
                          onChanged: (value) {
                            setState(() {
                              userType = value as String;
                            });
                          },
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        initialValue: phoneNumber,
                        maxLength: 13, // Set max length to 12 (+20 and 10 numbers)
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          if (value.length >= 3 && !value.startsWith('+20')) {
                            phoneNumber = '+20' + value.substring(3);
                            setState(() {});
                          } else if (value.startsWith('+20') && value.length > 13) {
                            phoneNumber = value.substring(0, 13);
                            setState(() {});
                          } else {
                            phoneNumber = value;
                          }
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (userType.isNotEmpty &&
                            name.isNotEmpty &&
                            phoneNumber.length == 13 &&
                            phoneNumber.startsWith('+20')) {
                          String collection =
                          userType == 'customer' ? 'Customer' : 'sellers';
                          await FirebaseFirestore.instance
                              .collection(collection)
                              .doc(uid)
                              .set({
                            'userType': userType,
                            'name': name,
                            'phoneNumber': phoneNumber,
                            'email': email,
                            // Add more user details if needed
                          });


                          Navigator.of(context).pop(); // Close the dialog here

                        } else {
                          // Show error or prompt to fill all fields
                          _showIncompleteInfoMessage(context); // Show error message
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                );
              });
            },
          );
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      _showSnackBar('Error signing in with Google.');
    }
  }



  void _showIncompleteInfoMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please fill in all the fields.'),
        duration: Duration(seconds: 2), // Adjust duration as needed
      ),
    );
  }



  Future<void> _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
      }
    });
  }



  Future<void> _saveRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('email', emailController.text);
    } else {
      await prefs.remove('email');
    }
  }



  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSignInSuccessMessage() {
    final snackBar = SnackBar(
      content: Text('Successfully signed in!'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      print("Trying to sign in...");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        _saveRememberMeStatus();
        String uid = userCredential.user!.uid;

        DocumentSnapshot userSnapshot;
        String userType = '';

        // Check if the user exists in the 'Customer' collection
        userSnapshot = await FirebaseFirestore.instance
            .collection('Customer')
            .doc(uid)
            .get();


      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('Account not found!');
      } else if (e.code == 'wrong-password') {
        _showSnackBar('Incorrect password.');
      } else {
        print("Error signing in: $e");
        _showSnackBar('Error signing in,check your email or password');
        // Show a generic error message or handle other Firebase Auth exceptions
      }
    } catch (e) {
      print("Error signing in: $e");
      _showSnackBar('Error signing in,check your email or password');
      // Handle other generic exceptions here
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Text(
                "   LOG-IN",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),

        backgroundColor: Color(0xFF223D60),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                "Let's Sign You In",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold , color:Color(0xFF223D60)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Text(
                "Welcome To our Nutrition App",
                style: TextStyle(fontSize: 15, color: Color(0xFF223D60)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your Email!',
                  prefixIcon: Icon(Icons.email),
                  label: Text('Email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                  ),                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter your Password!',
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                  ),                  suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text('Remember Me', style: TextStyle(color: Color(0xFF223D60)),),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => recover(),
                      ),
                    );
                  },
                  child: Text(
                    'Forget Password    ',
                    style: TextStyle(
                      color: Color(0xFFb08e6b),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 29),
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF223D60),
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()), // Navigate to CardPage
                    );
                  },
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                width: 250,
                height: 40,
                child: OutlinedButton(
                  onPressed: signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(
                      width: 1.5,
                      color: Colors.black,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/image/pngwing.com (13).png',
                        height: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 75),
              child: Row(
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: Text(
                      'Sign Up    ',
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