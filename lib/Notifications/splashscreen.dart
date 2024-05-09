import 'dart:math';

import 'package:flutter/material.dart' ;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nutrition_app/Notifications/mainscreen2.dart';
import 'package:nutrition_app/Notifications/stat.dart';
import 'package:workmanager/workmanager.dart';






 late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future showNotification() async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    '0.0',
    'Reminder',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Reminder Notification',
    "Let's Take Your Medicine!",
    platformChannelSpecifics,
  );



}



void callbackDispatcher() {

  // initial notifications
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');


  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,

  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );


  Workmanager().executeTask((task, inputData) {
    showNotification();
    return Future.value(true);
  });
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2) ,(){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder:(_) => MainScreen2()
      ));
    });

    Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash' ,style: TextStyle(fontSize: 70),),
      ),
    );
  }
}