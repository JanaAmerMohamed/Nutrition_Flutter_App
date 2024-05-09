import 'dart:async';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/widgets.dart'; // Import WidgetsFlutterBinding
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static StreamController<NotificationResponse> streamController =
  StreamController();

  static void onTap(NotificationResponse? notificationResponse) {}

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// Initialize timezone library
    tz.initializeTimeZones();

    // Set local location
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    try {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onTap,
        onDidReceiveNotificationResponse: onTap,
      );
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  // static Future<void> showBasicNotification() async {
  //   try {
  //     NotificationDetails details = NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'id 1',
  //         'basic notification',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //     );
  //     await flutterLocalNotificationsPlugin.show(
  //       0,
  //       'Reminder Notification',
  //       "It's time to take your Drug!",
  //       details,
  //     );
  //   } catch (e) {
  //     print('Error showing notification: $e');
  //   }
  // }

  // static Future<void> showRepeatedNotification(DateTime notificationTime) async {
  //   try {
  //     NotificationDetails details = NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'id 1',
  //         'basic notification',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //     );
  //
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       1, // Use a unique id for each notification
  //       'Reminder Notification',
  //       "It's time to take your Drug!",
  //       tz.TZDateTime.from(notificationTime, tz.local),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'id 1',
  //           'basic notification',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //         ),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //     );
  //   } catch (e) {
  //     print('Error showing notification: $e');
  //   }
  // }

  static Future<void> showschedualNotification() async {
    try {
      NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          'id 1',
          'bshedual notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      await flutterLocalNotificationsPlugin.periodicallyShow(
        2,
        'Reminder Notification',
        "It's time to take your Drug!",
        RepeatInterval.everyMinute, // Adjust the repeat interval as needed
        details,
        androidAllowWhileIdle: true,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // static void showBasicNotification2() async {
  //   AndroidNotificationDetails android = AndroidNotificationDetails(
  //       'id 3', 'basic notification1',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       sound:
  //       RawResourceAndroidNotificationSound('sound.wav'.split('.').first));
  //   NotificationDetails details = NotificationDetails(
  //     android: android,
  //   );
  //   await flutterLocalNotificationsPlugin.show(
  //     4,
  //     'Basic Notification',
  //     'body',
  //     details,
  //     payload: "Payload Data",
  //   );
  // }

  static void showDailySchduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'daily schduled notification',
      'id 4',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    var currentTime = tz.TZDateTime.now(tz.local);
    log("currentTime.year:${currentTime.year}");
    log("currentTime.month:${currentTime.month}");
    log("currentTime.day:${currentTime.day}");
    log("currentTime.hour:${currentTime.hour}");
    log("currentTime.minute:${currentTime.minute}");
    log("currentTime.second:${currentTime.second}");
    var scheduleTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      currentTime.hour,
      7,
    );
    log("scheduledTime.year:${scheduleTime.year}");
    log("scheduledTime.month:${scheduleTime.month}");
    log("scheduledTime.day:${scheduleTime.day}");
    log("scheduledTime.hour:${scheduleTime.hour}");
    log("scheduledTime.minute:${scheduleTime.minute}");
    log("scheduledTime.second:${scheduleTime.second}");
    if (scheduleTime.isBefore(currentTime)) {
      scheduleTime = scheduleTime.add(const Duration(hours: 1));
      log("AfterAddedscheduledTime.year:${scheduleTime.year}");
      log("AfterAddedscheduledTime.month:${scheduleTime.month}");
      log("AfterAddedscheduledTime.day:${scheduleTime.day}");
      log("AfterAddedscheduledTime.hour:${scheduleTime.hour}");
      log("AfterAddedscheduledTime.minute:${scheduleTime.minute}");
      log("AfterAddedscheduledTime.second:${scheduleTime.second}");
      log('Added Duration to scheduled time');
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      'Daily Schduled Notification',
      'body',
      scheduleTime,
      details,
      payload: 'zonedSchedule',
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
