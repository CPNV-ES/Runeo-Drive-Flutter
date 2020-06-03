import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._internal() {
    // save the client so that it can be used else where
    _firebaseMessaging = FirebaseMessaging();
  }

  static final FirebaseMessagingService _instance =
    FirebaseMessagingService._internal();

  static FirebaseMessagingService get instance {
    return _instance;
  }

  FirebaseMessaging _firebaseMessaging;

  // getter for firebase messaging client
  get firebaseMessaging => _firebaseMessaging;

  /// Get firebase token
  Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Ask for permission on IOS
  void getIOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  /// Subscribe to a topic
  /// 
  /// Take [topic] as an argument
  void firebaseSubscribe(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe to a topic
  /// 
  /// Take [topic] as an argument
  void firebaseUnsubscribe(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}