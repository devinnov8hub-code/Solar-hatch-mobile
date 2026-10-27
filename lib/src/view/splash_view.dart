import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/core/app_assets.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';
import 'package:solar_hatch_mobile/src/view/dashboard_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const DashboardView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.splashBG, fit: BoxFit.cover),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 36,
                ).r,
                child: SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentYellow,
                      foregroundColor: AppColors.primaryDarkGreen,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12).r,
                      ),
                    ),
                    onPressed: _navigateToDashboard,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Go To Dashboard',
                          style: TextStyle(
                            fontSize: 16.spMin,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        8.horizontalSpace,
                        Icon(
                          Icons.arrow_forward,
                          size: 20.r,
                          color: AppColors.primaryDarkGreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
