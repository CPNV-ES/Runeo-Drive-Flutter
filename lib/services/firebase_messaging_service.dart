import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._internal() {
    // save the client so that it can be used else where
    _firebaseMessaging = FirebaseMessaging();
    // setup listeners
    firebaseCloudMessagingListeners();
  }

  static final FirebaseMessagingService _instance =
    FirebaseMessagingService._internal();

  static FirebaseMessagingService get instance {
    return _instance;
  }

  FirebaseMessaging _firebaseMessaging;

  // getter for firebase messaging client
  get firebaseMessaging => _firebaseMessaging;

  Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) getIOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void getIOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}