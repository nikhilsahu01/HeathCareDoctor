import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../screens/home/view_model/home_viewModel.dart';
import '../../screens/appointments/viewModel/appointments_viewModel.dart';
import '../../screens/notifications/view_model/notification_view_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: ${message.notification?.title}");
  if (message.notification != null) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: message.notification?.title,
        body: message.notification?.body,
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: message.notification?.android?.imageUrl ?? message.data?['image'],
        payload: {'screen': message.data?['screen'] ?? 'home', 'id': message.data?['id']},
      ),
    );
  }
}

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _isInitialized = false;
  late BuildContext context;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    // context = passedContext;

    try {
      // 🔔 Request Firebase Notification Permission
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print('⚠️ Notification permission not granted');
        return;
      }

      // ✅ Get FCM Token and store
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("deviceToken", token);
        print("📲 FCM Token: $token");
        // MOCK: Save FCM token to backend
        _mockSaveTokenToBackend(token);
      }

      // 🎯 Foreground Notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Foreground Notification Received: ${message.notification?.title}");
        
        final context = MyApp.navigatorKey.currentContext;
        if (context != null) {
          Provider.of<HomeViewModel>(context, listen: false).fetchHomeData();
          Provider.of<AppointmentViewModel>(context, listen: false).fetchUpcomingAppointments();
          Provider.of<NotificationViewModel>(context, listen: false).fetchNotifications();
        }

        if (message.notification != null) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              channelKey: 'basic_channel',
              title: message.notification?.title,
              body: message.notification?.body,
              notificationLayout: NotificationLayout.BigPicture,
              bigPicture: message.notification?.android?.imageUrl ?? message.data['image'],
              payload: {'screen': message.data['screen'] ?? 'home', 'id': message.data['id']},
            ),
          );
        }
      });

      // 🟡 Background / Terminated → App Opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("📲 App opened via notification");

      });
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction action) async {
          await handleNotificationAction(action, context);
        },
      );


    } catch (e) {
      print("❌ Firebase Notification Init Error: $e");
    }
  }
  Future<void> handleNotificationAction(ReceivedAction action, BuildContext context) async {
    if (action.payload?['screen'] == 'home') {

    } else if (action.payload?['screen'] == 'appointment_details') {
      // Redirect to appointment details
      final id = action.payload?['id'];
      if (id != null) {
        // e.g. Navigator.pushNamed(context, '/appointment_details', arguments: id);
        print("Redirecting to appointment $id");
      }
    }
  }

  Future<void> _mockSaveTokenToBackend(String token) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    print("MOCK API: Saved FCM Token $token successfully");
  }
}
