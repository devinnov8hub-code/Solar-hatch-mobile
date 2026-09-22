import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/core/app_assets.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';
import 'package:solar_hatch_mobile/src/view/widgets/notifications_view.dart';
import 'package:solar_hatch_mobile/src/widgets/incubation_status_card.dart';
import 'package:solar_hatch_mobile/src/widgets/network_status_card.dart';
import 'package:solar_hatch_mobile/src/widgets/system_diagnostic_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundScaffold,
        elevation: 0,
        title: Row(
          children: [
            // Placeholder for Logo, using Splash.png cropped or scaled
            Image.asset(
              AppAssets.logo,
              height: 55.h,
              width: 82.w,
              fit: BoxFit.cover,
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16).r,
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.accentYellow,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsView()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
            // Network Status
            const NetworkStatusCard(),
            const SizedBox(height: 24),

            // System Diagnostics Section
            Container(
              padding: const EdgeInsets.all(16).r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9CB78), Color(0xFFE4F0D3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionHeader(
                    icon: AppAssets.pulseIcon,
                    title: 'SYSTEM DIAGNOSTICS',
                  ),
                  14.verticalSpace,
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.7,
                    children: const [
                      SystemDiagnosticCard(
                        icon: AppAssets.settingsIcon,
                        title: 'System Health',
                        status: DiagnosticStatus.operational,
                        description: 'All systems Normal',
                      ),
                      SystemDiagnosticCard(
                        icon: AppAssets.humidifierIcon,
                        title: 'Humidifier',
                        status: DiagnosticStatus.warning,
                        description: '',
                      ),
                      SystemDiagnosticCard(
                        icon: AppAssets.heaterIcon,
                        title: 'Heater',
                        status: DiagnosticStatus.operational,
                        description: 'Temperature stable',
                      ),
                      SystemDiagnosticCard(
                        icon: AppAssets.motorSensorIcon,
                        title: 'Motor Sensor',
                        status: DiagnosticStatus.operational,
                        description: '',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            24.verticalSpace,

            // Incubation Status Section
            _buildSectionHeader(
              icon: AppAssets.hourGlassHighIcon,
              title: 'Incubation Status',
            ),
            12.verticalSpace,
            const IncubationStatusCard(
              icon: AppAssets.temperatureIcon,
              title: 'Temperature',
              value: '30°C',
            ),
            const IncubationStatusCard(
              icon: AppAssets.humidityIcon,
              title: 'Humidity',
              value: '10%RH',
            ),
            const IncubationStatusCard(
              icon: AppAssets.calendarIcon,
              title: 'Total Days',
              value: '21',
            ),
            const IncubationStatusCard(
              icon: AppAssets.incubationIcon,
              title: 'Days left',
              value: '13',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6).r,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 238, 202, 1),
            shape: BoxShape.circle,
          ),
          child: Image.asset(icon, width: 20),
        ),
        8.horizontalSpace,
        Text(
          title,
          style: TextStyle(
            color: AppColors.primaryDarkGreen,
            fontSize: 16.spMin,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
