import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseCloudMessaging {
  static FirebaseCloudMessaging _instance = FirebaseCloudMessaging._internal();

  factory FirebaseCloudMessaging() => _instance;

  FirebaseCloudMessaging._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging();

  void initialize() {
    _messaging.getToken().then((token) {
      print("\n******\nFirebase Token $token\n******\n");
    });

    _messaging.subscribeToTopic('all');

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('\n\n\n*** on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('\n\n\n*** on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('\n\n\n*** on launch $message');
      },
//      onBackgroundMessage: (Map<String, dynamic> message) async {
//        print('\n\n\n*** on background message $message');
//      },
    );

    if (Platform.isIOS) {
      _messaging.requestNotificationPermissions(
          IosNotificationSettings(alert: true, badge: true, sound: true));

      _messaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("iOS Push Settings: [$settings]");
      });
    }
  }
}
