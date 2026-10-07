import 'package:flutter/material.dart';
import 'package:solar_hatch_mobile/src/core/app_assets.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToDashBoard();
    });
  }

  void _navigateToDashBoard() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (context) => const DashboardView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(AppAssets.splashBG, fit: BoxFit.cover),
      ),
    );
  }
}
