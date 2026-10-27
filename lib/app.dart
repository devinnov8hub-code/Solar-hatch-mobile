import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/view/splash_view.dart';

class SolarHatch extends StatelessWidget {
  const SolarHatch({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(383, 852),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (BuildContext context, Widget? child) => MaterialApp(
        title: 'Solar Hatch',
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
      ),
    );
  }
}
