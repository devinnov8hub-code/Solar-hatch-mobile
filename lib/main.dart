import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_hatch_mobile/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// For restricting the app to portrait mode only
  unawaited(
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  );

  runApp(const SolarHatch());
}
