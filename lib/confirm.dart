import 'package:flutter/material.dart';
import 'package:nutrition_app/loginpage.dart';

class confirm extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<confirm> {
  @override
  void initState() {
    super.initState();
    // Simulate loading for 5 seconds
    Future.delayed(Duration(seconds: 1), () {
      // Navigate to the "Done" page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => confirmpage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFb08e6b)),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Color(0xFFb08e6b)),
            ),
          ],
        ),
      ),
    );
  }
}

class confirmpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF223D60),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.done_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Email is Registered",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Color(0xFF223D60)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 60, right: 50),
                child: Text(
                  "You Can Sign In Now!",
                  style: TextStyle(fontSize: 15, color: Color(0xFF223D60)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: SizedBox(
                  width: 290,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF223D60), // Grey color
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage() ),
                      );
                    },
                    child: Text(
                      'Sign In ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}