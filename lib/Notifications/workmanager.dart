//
// import 'package:nutrition_app/Notifications/notification.dart';
// import 'package:workmanager/workmanager.dart';
//
//
// class WorkManagerService {
//   void registerMyTask() async {
//     //register my task
//     await Workmanager().registerPeriodicTask(
//       'id1',
//       'show simple notification',
//       frequency: const Duration(minutes: 120),
//     );
//   }
//
//   //init work manager service
//   Future<void> init() async {
//     await Workmanager().initialize(actionTask, isInDebugMode: true);
//     registerMyTask();
//   }
//
//   void cancelTask(String id) {
//     Workmanager().cancelAll();
//   }
// }
//
// @pragma('vm-entry-point')
// void actionTask() {
//   //show notification
//   Workmanager().executeTask((taskName, inputData) {
//     LocalNotificationService.showDailySchduledNotification();
//     return Future.value(true);
//   });
// }
//
// //1.schedule notification at 9 pm.
// //2.execute for this notification.