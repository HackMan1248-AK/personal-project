import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/Task.dart';

class NotificationService {
  // Singleton setup
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // INIT
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Initialize timezones
    tz_data.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('Asia/Kolkata'),
    ); // Adjust timezone as needed

    // Android Settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(settings: initSettings);

    _isInitialized = true;
  }

  // Notification Detail
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        "Daily Notifications",
        channelDescription: "Daily Notification Channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(),
    );
  }

  // INSTANT NOTIFICATION
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          channelDescription: 'Instant notification channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // SCHEDULED NOTIFICATION
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel_id',
          'Scheduled Notifications',
          channelDescription: 'Scheduled notification channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // SCHEDULE DEADLINE NOTIFICATIONS BASED ON URGENCY
  Future<void> scheduleDeadlineNotifications(Task task) async {
    if (task.difficulty == null ||
        task.timeIntensive == null ||
        task.fromTime == null ||
        task.toTime == null ||
        task.toDate == null) {
      return;
    }

    // Parse times
    List<String> fromParts = task.fromTime!.split(':');
    List<String> toParts = task.toTime!.split(':');
    DateTime start = DateTime(
      task.fromDate?.getDateTime().year ?? DateTime.now().year,
      task.fromDate?.getDateTime().month ?? DateTime.now().month,
      task.fromDate?.getDateTime().day ?? DateTime.now().day,
      int.parse(fromParts[0]),
      int.parse(fromParts[1]),
    );
    DateTime deadline = DateTime(
      task.toDate!.getDateTime().year,
      task.toDate!.getDateTime().month,
      task.toDate!.getDateTime().day,
      int.parse(toParts[0]),
      int.parse(toParts[1]),
    );

    Duration duration = deadline.difference(start);
    int durationMinutes = duration.inMinutes;
    DateTime now = DateTime.now();
    if (deadline.isBefore(now)) return; // past deadline

    Duration timeRemaining = deadline.difference(now);
    double timeRatio = timeRemaining.inMinutes / durationMinutes.toDouble();
    if (timeRatio > 1) timeRatio = 1.0;
    double urgencyScore = (task.difficulty! + task.timeIntensive!) / 2.0;

    // For high urgency, schedule notifications
    if (urgencyScore >= 4) {
      // Schedule at deadline - duration * 0.5
      DateTime notifyTime1 = deadline.subtract(
        Duration(minutes: (durationMinutes * 0.5).round()),
      );
      if (notifyTime1.isAfter(now)) {
        await scheduleNotification(
          id: int.parse(task.id) * 10 + 1,
          title: 'Task Reminder',
          body: '${task.name} is halfway to deadline.',
          scheduledDate: notifyTime1,
        );
      }

      // Schedule at deadline - duration * 0.2
      DateTime notifyTime2 = deadline.subtract(
        Duration(minutes: (durationMinutes * 0.2).round()),
      );
      if (notifyTime2.isAfter(now)) {
        await scheduleNotification(
          id: int.parse(task.id) * 10 + 2,
          title: 'Task Reminder',
          body: '${task.name} deadline approaching.',
          scheduledDate: notifyTime2,
        );
      }

      // Schedule at deadline - 10 minutes
      DateTime notifyTime3 = deadline.subtract(Duration(minutes: 10));
      if (notifyTime3.isAfter(now)) {
        await scheduleNotification(
          id: int.parse(task.id) * 10 + 3,
          title: 'Task Reminder',
          body: '${task.name} due in 10 minutes!',
          scheduledDate: notifyTime3,
        );
      }
    }
  }
}
