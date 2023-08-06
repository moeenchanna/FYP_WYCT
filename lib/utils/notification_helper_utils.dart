
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_what_you_cook_today/utils/helper_utils.dart';

import '../firebase_options.dart';

class NotificationHelper {
  NotificationDetails get _ongoing {
    const androidChannelSpecifics = AndroidNotificationDetails(
      'fyp-id',
      'fyp-name',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
    );
    return const NotificationDetails(
        android: androidChannelSpecifics, iOS: IOSNotificationDetails());
  }

  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await initFirebase();
  // }

  String? currentUserEmail;

  getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await requestPermission(messaging);
    var test = await token();
    log(test);

  }

  Future<String> token() async {
    try {
      return await FirebaseMessaging.instance.getToken() ?? "";
    } catch (e) {
      return '';
    }
  }

  configure() async {
    await initFirebase();
    final String? token = await getToken();

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final notification = await setupLocalNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (!Platform.isIOS) {
        showNotification(
          notification,
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data,
          type: _ongoing,
        );
      }
    });

    return token;
  }



  Future<void> requestPermission(FirebaseMessaging messaging) async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  setupLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(
      'ic_launcher',
    );
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) {},
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    var notification = FlutterLocalNotificationsPlugin();
    await notification.initialize(initializationSettings,
        onSelectNotification: (_) {});
    return notification;
  }

  showNotification(FlutterLocalNotificationsPlugin notifications,
      {required String? title,
        required String? body,
        required NotificationDetails type,
        required payload}) {
    notifications.show(HelperUtils().generateRandomId(), title, body, type, payload: json.encode(payload ?? {}));
  }
}

// pushNotificationsSpecificDevice(
// token: widget.targetUser.token,
// title: "Checkout Our New Product",
// body: "Product: $productDetail Product Detail: $productDetail Product Detail: $productPrice");
//
// log("Notification sent");