import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_web/firebase_messaging_web.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/constants/rapyderrorcodes.dart';
import 'package:lilo/repositories/user_repo.dart';
import 'package:lilo/views/main_home/main_home.dart';

class Appmodel {
  // FirebaseMessagingWeb
  FirebaseMessaging messaging;
  UserRepository userRepository = Get.find();
  Appmodel({required this.messaging});

  userLoggedIn() async {
    NotificationSettings settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized)
      // NotificationSettings
      settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    print('User granted permission: ${settings.authorizationStatus}');
    String? userToken = await messaging.getToken(

        // );
        vapidKey:
            "BEPvdhzVTfG0y_bqVBoMcmztkfJfmNuVtNid8P0hrEDMmyIwzdwk6KSKPU1PG9mmiDSzxryX_rhbmIYBDAn9cE0");

    await saveTokenToDatabase(userToken!);
    // FirebaseMessaging.onBackgroundMessage((message) {
    //   return printItOut(message);
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        String title = message.notification!.title!;
        String body = message.notification!.body!;
        Get.defaultDialog(title: title, content: Text(body));
      }
    });
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    await userRepository.saveToken(token);
  }

  // Future<void> printItOut(RemoteMessage message) async {
  //   // Assume user is logged in for this example
  //   print("got a message while in the background");
  // }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
}
