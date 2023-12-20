import 'dart:math';

import 'package:autozone/app/home/home_page.dart';
import 'package:autozone/app/registration/registration.dart';
import 'package:autozone/domain/dependency_injection.dart';
import 'package:autozone/firebase_options.dart';
import 'package:autozone/utils/service_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

var firebaseMessaging = FirebaseMessaging.instance;

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await AwesomeNotifications().initialize(
      null, //'resource://drawable/res_app_icon',//
      [
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private)
      ],
      debug: true);

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) return;

  // int randomNumber = Random().nextInt(100);

  // await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //         id: randomNumber,
  //         channelKey: 'alerts',
  //         title: message.notification!.title,
  //         body: message.notification!.body,
  //         payload: {"id": message.data["id"]}));
}

void main() async {
  var serviceCollection = ServiceCollection();

  serviceCollection.addDomain();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      name: '[DEFAULT]', options: DefaultFirebaseOptions.currentPlatform);

  await firebaseMessaging.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  firebaseMessaging.onTokenRefresh.listen((token) async {
    var prefs = await SharedPreferences.getInstance();

    Dio dio = Dio();

    var body = {
      "deviceToken": token,
    };

    await dio.patch("https://autozone.onepay.am/api/v1/users/updateDeviceToken",
        data: body,
        options: Options(
          headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
          validateStatus: (status) {
            return true;
          },
        ));
  });

  late Widget app;

  var prefs = await SharedPreferences.getInstance();

  if (prefs.getString("token") != null) {
    app = const MaterialApp(
      title: 'Autozone',
      home: HomePage(
        isRedirect: false,
      ),
    );
  } else {
    app = const App();
  }

  runApp(app);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

bool hasInternet = true;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Autozone',
      home: Registration(),
    );
  }
}
