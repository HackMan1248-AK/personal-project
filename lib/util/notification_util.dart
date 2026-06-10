// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart';
// import 'package:personal_project_v2/util/notification_service.dart'; // Add this import

// Future<void> showInstantNotification({
//   required int id,
//   required String title,
//   required String body,
// }) async {
//   await NotificationService().notificationsPlugin.show(
//     // Reference via singleton
//     id,
//     title,
//     body,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'instant_notification_channel_id',
//         'Instant Notifications',
//         channelDescription: 'Instant notification channel',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     ),
//   );
// }
