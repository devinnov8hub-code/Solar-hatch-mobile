import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:solar_hatch_mobile/src/model/alert_data.dart';
import 'package:solar_hatch_mobile/src/model/incubation_data.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Stream<IncubationData> get incubationDataStream {
    return _dbRef.child('test').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return IncubationData.fromJson(data);
      }
      return IncubationData.initial();
    });
  }

  Stream<List<AlertData>> get alertsStream {
    return _dbRef.child('alerts').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final alerts = <AlertData>[];
        data.forEach((key, value) {
          alerts.add(
            AlertData.fromJson(key.toString(), value as Map<dynamic, dynamic>),
          );
        });
        return alerts.reversed.toList();
      }
      return [];
    });
  }

  Future<void> initNotifications() async {
    final settings = await _fcm.requestPermission();
    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // On iOS, we need the APNS token before we can get the FCM token
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        final apnsToken = await _fcm.getAPNSToken();
        if (apnsToken == null) {
          if (kDebugMode) {
            print(
              'APNS token not available. If you are on an iOS simulator, push notifications are not supported.',
            );
          }
          return; // Abort token generation
        }
      }

      final token = await _fcm.getToken();
      if (kDebugMode) {
        print('FCM Token: $token');
      }

      if (token != null) {
        await _dbRef.child('fcmTokens').child(token).set({
          'token': token,
          'createdAt': ServerValue.timestamp,
        });
      }

      _fcm.onTokenRefresh.listen((newToken) {
        _dbRef.child('fcmTokens').child(newToken).set({
          'token': newToken,
          'createdAt': ServerValue.timestamp,
        });
      });
    }
  }
}
