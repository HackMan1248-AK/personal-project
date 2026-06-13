import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:ClassViz/amplifyconfiguration.dart';
import 'package:ClassViz/pages/auth/auth_page.dart';
import 'package:ClassViz/pages/home_page.dart';
import 'package:ClassViz/pages/profile_page.dart';
import 'package:ClassViz/pages/projects_page.dart';
import 'package:ClassViz/pages/tasks_page.dart';
import 'package:ClassViz/util/notification_service.dart';
import 'package:ClassViz/util/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:ClassViz/models/ModelProvider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
/*import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:usage_stats/usage_stats.dart';*/
import 'dart:async';

/*void onStart(ServiceInstance service) {
  const blacklist = ['com.instagram.android', 'com.google.android.youtube'];

  Timer.periodic(Duration(seconds: 3), (timer) async {
    service.on('stop').listen((event) {
      timer.cancel();
    });

    List<UsageInfo> usageStats = await UsageStats.queryUsageStats(
      DateTime.now().subtract(Duration(seconds: 10)),
      DateTime.now(),
    );

    UsageInfo? info = usageStats.lastWhere((e) => e.packageName != null);

    if (blacklist.contains(info.packageName)) {
      FlutterOverlayWindow.showOverlay(
        height: 600,
        width: 400,
        alignment: OverlayAlignment.center,
        enableDrag: false,
        overlayTitle: "Blocked",
        overlayContent: "This app is blocked.",
      );
    }
  });
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(
    ChangeNotifierProvider(create: (context) => TaskProvider(), child: MyApp()),
  );
}

Future<void> init() async {
  // Gemini.init(apiKey: "AIzaSyCAPrkVWrlFLZZb3HTqfKuDaKjaMspXKqE");

  final authPlugin = AmplifyAuthCognito();
  final apiPlugin = AmplifyAPI();
  final datastorePlugin = AmplifyDataStore(
    modelProvider: ModelProvider.instance,
  );
  await Amplify.addPlugins([authPlugin, apiPlugin, datastorePlugin]);
  await Amplify.configure(amplifyconfig);
  NotificationService().initNotification();

  /*if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission();
  }

  bool accessGranted = await UsageStats.checkUsagePermission() ?? false;
  if (!accessGranted) {
    UsageStats.grantUsagePermission();
  }
 
  await FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(),
  );

  await FlutterBackgroundService().startService();*/
}

Future<void> init_notif() async {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeTimeZones();

  setLocalLocation(getLocation('Asia/Kolkata'));

  const androidSettings = AndroidInitializationSettings(
    '@mipmap/launcher_icon',
  );
  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(settings: initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.\
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassViz',
      theme: ThemeData(
        useMaterial3: true,

        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: "Roboto",
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),

        scaffoldBackgroundColor: Colors.black,

        colorScheme: const ColorScheme(
          brightness: Brightness.dark,

          // Main mint accent
          primary: Color(0xFF14E0A1),
          onPrimary: Colors.black,

          // Secondary accent
          secondary: Color(0xFF7AF5D0),
          onSecondary: Colors.black,

          // Error
          error: Color(0xFFFF5252),
          onError: Colors.white,

          // Dark surfaces
          surface: Color(0xFF121212),
          onSurface: Colors.white,
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF151515),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white12),
          ),
        ),

        dividerColor: Colors.white10,

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF151515),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF14E0A1), width: 1.5),
          ),

          hintStyle: const TextStyle(color: Colors.white54),
        ),

        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF14E0A1),
          linearTrackColor: Color(0xFF2A2A2A),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        "/loginpage": (context) => const AuthPage(),
        "/projectspage": (context) => const ProjectsPage(),
        "/profilepage": (context) => const ProfilePage(),
        "/taskspage": (context) => const TaskPage(),
        "/homepage": (context) => HomePage(),
      },
    );
  }
}
