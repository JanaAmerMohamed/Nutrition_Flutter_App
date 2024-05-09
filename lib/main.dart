import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrition_app/BMI.dart';
import 'package:nutrition_app/Notifications/mainscreen.dart';
import 'package:nutrition_app/Notifications/notification.dart';
import 'package:nutrition_app/Notifications/splashscreen.dart';
import 'package:nutrition_app/intro.dart';
import 'package:nutrition_app/ocr.dart';
import 'firebase_options.dart';
import 'package:nutrition_app/Gemini/const.dart';
import 'package:nutrition_app/Gemini/homepage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
Future <void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  if(kDebugMode){
    print(message.messageId);}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that bindings are initialized
  await LocalNotificationService.init(); // Initialize local notifications
  tz.initializeTimeZones(); // Initialize timezones

  // Set local location
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Gemini.init(apiKey: gemini_apikey); // Initialize Gemini or any other services

  runApp(intro()); // Run your app, assuming intro() returns a widget
}


