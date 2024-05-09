import 'package:flutter/material.dart';
import 'package:nutrition_app/loginpage.dart';


class LoadingPage5 extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage5> {
  @override
  void initState() {
    super.initState();
    // Simulate loading for 5 seconds
    Future.delayed(Duration(seconds: 1), () {
      // Navigate to the "Done" page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>messageupdate(),
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

class messageupdate extends StatelessWidget {
  const messageupdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),

            onPressed: () {
              // Handle cancel button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFb08e6b),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor:Color(0xFFb08e6b),
                    child: Icon(
                      Icons.verified_outlined,
                      size: 40,
                      color: Colors.white,

                    ),

                  ),

                ),

              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text("Check your email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                child: Text("Please click on the link sent to your email to update your password and then log in again.",style: TextStyle(fontSize: 15),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150,left: 8),
                child: SizedBox(
                  width: 290,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFb08e6b),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the AboutPage
                      );
                    },
                    child: Text(
                      'LOG IN',
                      style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
