import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nutrition_app/Notifications/details.dart';
import 'package:nutrition_app/Notifications/notification.dart';
import 'package:nutrition_app/Notifications/splashscreen.dart';
import 'package:nutrition_app/entry_data.dart';
import 'package:workmanager/workmanager.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late int frequencyInHours;
  void initState() {
    frequencyInHours = 6; // Default frequency of 6 hours

    // Logic to get user input for frequency (you can replace this with your own logic)
    // For example, you can prompt the user for input or fetch it from a settings screen
    // Assume userInput is a valid integer representing the desired frequency

    // Convert the user input to an integer (assuming it's a valid integer)
    int? userInput = 3; // For example, 3 hours

    // Check if userInput is a valid integer and greater than 0
    if (userInput != null && userInput > 0) {
      frequencyInHours = userInput;
    }

    // Register the periodic task with the specified frequency
    Workmanager().initialize(
      callbackDispatcher, // Your callback function
      isInDebugMode: false,
    );
    Workmanager().registerPeriodicTask(
      "1",
      "periodic Notification every $frequencyInHours hours",
      frequency: Duration(hours: frequencyInHours),
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Notification Tutorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    listenToNotificationStream();
  }

  void listenToNotificationStream() {
    LocalNotificationService.streamController.stream.listen(
          (notificationResponse) {
        log(notificationResponse.id!.toString());
        log(notificationResponse.payload!.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailsScreen(
              response: notificationResponse,
            ),
          ),
        );
      },
    );
  }

  void navigateToEntryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EntryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        leading: const Icon(Icons.notifications),
        titleSpacing: 0.0,
        title: const Text('Flutter Local Notification Tutorial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: navigateToEntryScreen,
              leading: const Icon(Icons.notifications),
              title: const Text('Schedule Notification'),
              subtitle: const Text('Select time and interval'),
            ),
            // ListTile(
            //   onTap: ,
            //   leading: const Icon(Icons.notifications),
            //   title: const Text('Schedule Notification'),
            //   subtitle: const Text('Select time and interval'),
            // ),
          ],
        ),
      ),
    );
  }
}

class EntryScreen extends StatelessWidget {
  const EntryScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataEntry(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Logic to submit and schedule notification
                      LocalNotificationService.showschedualNotification();
                      Navigator.pop(context); // Go back to HomeScreen
                    },
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logic to submit and schedule notification
                      LocalNotificationService.cancelNotification(2);
                      Navigator.pop(context); // Go back to HomeScreen
                    },
                    child: const Text('Cancel Notification'),
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
