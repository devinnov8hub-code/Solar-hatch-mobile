import 'dart:async';

import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_hatch_mobile/app.dart';
import 'package:solar_hatch_mobile/firebase_options.dart';
import 'package:solar_hatch_mobile/src/controller/firebase_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // We wrap in a try-catch to not block app startup if network is unavailable
  try {
    await FirebaseService().initNotifications();
  } catch (e) {
    debugPrint('Failed to init notifications: $e');
  }

  /// For restricting the app to portrait mode only
  unawaited(
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  );

  runApp(const SolarHatch());
}
