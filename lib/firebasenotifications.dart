import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class notification2 extends StatefulWidget {
  const notification2({super.key});

  @override
  State<notification2> createState() => _notification2State();
}

class _notification2State extends State<notification2> {
  void requestPermission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      sound: true,
      criticalAlert: false,
      provisional: false,

    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print("User Granted Permission");
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      // here is the action
      print('Title: ${message.notification?.title}| Body: ${message.notification?.body}');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "Remind me Notificatiions",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF223D60),
        ),
      body: Center(
        child: Text("Flutter Notifications"),
      ),
    );
  }
}
