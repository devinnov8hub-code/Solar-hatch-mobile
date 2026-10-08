import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/controller/firebase_service.dart';
import 'package:solar_hatch_mobile/src/core/app_assets.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';
import 'package:solar_hatch_mobile/src/model/incubation_data.dart';
import 'package:solar_hatch_mobile/src/view/notifications_view.dart';
import 'package:solar_hatch_mobile/src/widgets/incubation_status_card.dart';
import 'package:solar_hatch_mobile/src/widgets/network_status_card.dart';
import 'package:solar_hatch_mobile/src/widgets/system_diagnostic_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundScaffold,
        elevation: 0,
        title: Row(
          children: [
            // Placeholder for Logo, using Splash.png cropped or scaled
            Padding(
              padding: const EdgeInsets.all(8).r,
              child: Image.asset(
                AppAssets.logo,
                height: 55,
                width: 82,
                fit: BoxFit.fitHeight,
              ),
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
                  MaterialPageRoute<void>(
                    builder: (context) => const NotificationsView(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<IncubationData>(
        stream: _firebaseService.incubationDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryDarkGreen,
              ),
            );
          }

          final data = snapshot.data ?? IncubationData.initial();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,

                // Network Status

                ///TODO : Check the wifi status and display it
                NetworkStatusCard(isConnected: data.wifiStatus == 1),
                const SizedBox(height: 24),

                // System Diagnostics Section
                Container(
                  padding: const EdgeInsets.all(16).r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      opacity: .1,
                      fit: BoxFit.cover,
                      image: AssetImage(AppAssets.dashboardBg),
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF9CB78), Color(0xFFE4F0D3),

                        //  Color.fromRGBO(249, 172, 1, 1),
                        // Color(0xFFE4F0D3),
                      ],
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
                      Builder(
                        builder: (context) {
                          final humidityDiff =
                              (data.humidity - data.setHumidity).abs();
                          final isHumidifierWarning = humidityDiff > 5.0;

                          final tempDiff =
                              (data.temperature - data.setTemperature).abs();
                          final isHeaterWarning = tempDiff > 1.0;

                          final isSystemWarning =
                              isHumidifierWarning ||
                              isHeaterWarning ||
                              data.wifiStatus == 0;

                          return GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.7.sp,
                            children: [
                              SystemDiagnosticCard(
                                icon: AppAssets.settingsIcon,
                                title: 'System Health',
                                status: isSystemWarning
                                    ? DiagnosticStatus.warning
                                    : DiagnosticStatus.operational,
                                description: isSystemWarning
                                    ? 'Check subsystems'
                                    : 'All systems Normal',
                              ),
                              SystemDiagnosticCard(
                                icon: AppAssets.humidifierIcon,
                                title: 'Humidifier',
                                status: isHumidifierWarning
                                    ? DiagnosticStatus.warning
                                    : DiagnosticStatus.operational,
                                description: isHumidifierWarning
                                    ? 'Humidity out of range'
                                    : 'Humidity stable',
                              ),
                              SystemDiagnosticCard(
                                icon: AppAssets.heaterIcon,
                                title: 'Heater',
                                status: isHeaterWarning
                                    ? DiagnosticStatus.warning
                                    : DiagnosticStatus.operational,
                                description: isHeaterWarning
                                    ? 'Temp out of range'
                                    : 'Temperature stable',
                              ),
                              const SystemDiagnosticCard(
                                icon: AppAssets.motorSensorIcon,
                                title: 'Motor Sensor',
                                status: DiagnosticStatus.operational,
                                description: 'Operational',
                              ),
                            ],
                          );
                        },
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
                IncubationStatusCard(
                  icon: AppAssets.temperatureIcon,
                  title: 'Temperature',
                  value: '${data.temperature}°C',
                ),
                IncubationStatusCard(
                  icon: AppAssets.humidityIcon,
                  title: 'Humidity',
                  value: '${data.humidity}%RH',
                ),
                IncubationStatusCard(
                  icon: AppAssets.calendarIcon,
                  title: 'Total Days',
                  value: '${data.totalIncubationDays}',
                ),
                IncubationStatusCard(
                  icon: AppAssets.incubationIcon,
                  title: 'Days left',
                  value:
                      '${data.totalIncubationDays - data.currentIncubationDay}',
                ),
              ],
            ),
          );
        },
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
