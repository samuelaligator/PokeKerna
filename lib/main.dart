import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'navigation.dart';
import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await initNotifications();
  await scheduleTaskAtTimestamp();

  runApp(PokeKerna());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleTaskAtTimestamp() async {
  print("SCHEDULE STARTED");
  final prefs = await SharedPreferences.getInstance();
  final storedTimestamp = prefs.getInt('next_booster');

  if (storedTimestamp != null) {
    print("DOING SATANISTS STUFF");
    final targetTime = DateTime.fromMillisecondsSinceEpoch(storedTimestamp * 1000);
    final now = DateTime.now();
    print(targetTime);
    print(now);

    if (targetTime.isAfter(now)) {

      final delay = targetTime.difference(now);

      // Set up the Timer to execute the task after the delay
      Timer(delay, () {
        print("TIMER ENDED");
        showNotification("Scheduled Task", "It's time for your task!");
      });
    } else {
      showNotification("Booster Disponible !", "It's time for your task!");
    }
  }
}

// Show a notification
Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'default_channel',
    'Default Channel',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}

// This function sends a notification when the app starts
Future<void> showAppStartNotification() async {
  showNotification('App Started', 'Welcome to PokeKerna!');
}

class PokeKerna extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeKerna',
      theme: ThemeData(
        fontFamily: 'Outfit',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return NavigationBarPage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('api_key');
  }
}
