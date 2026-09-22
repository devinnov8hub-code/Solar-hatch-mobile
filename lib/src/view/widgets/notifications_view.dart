import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/core/app_assets.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';
import 'package:solar_hatch_mobile/src/widgets/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundScaffold,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16).r,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.1),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'Notifications & Alerts',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18.spMin,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    color: AppColors.primaryDarkGreen,
                    fontSize: 16.spMin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ).r,
                  decoration: BoxDecoration(
                    color: AppColors.alertRed,
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Dismiss All',
                        style: TextStyle(
                          color: AppColors.alertRedText,
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.close,
                        color: AppColors.alertRedText,
                        size: 16.r,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            const NotificationCard(
              icon: AppAssets.humidifierIcon,
              title: 'Humidifier Alert',
              description: 'Humidity levels low',
              time: '9:41 AM',
              isUnread: true,
            ),
            24.verticalSpace,
            Text(
              'Last week',
              style: TextStyle(
                color: AppColors.primaryDarkGreen,
                fontSize: 16.spMin,
                fontWeight: FontWeight.bold,
              ),
            ),
            16.verticalSpace,
            const NotificationCard(
              icon: AppAssets.humidifierIcon,
              title: 'Humidifier Alert',
              description: 'Humidity levels low',
              time: '9:41 AM',
            ),
            const NotificationCard(
              icon: AppAssets.temperatureIcon,
              title: 'Temperature sensor malfunction',
              description: 'Please check temperature sensor',
              time: '9:41 AM',
            ),
            const NotificationCard(
              icon: AppAssets.calendarIcon,
              title: 'Hatching period',
              description: 'Please move eggs to hatching chamber',
              time: '9:41 AM',
            ),
            const NotificationCard(
              icon: AppAssets.calendarIcon,
              title: 'Hatching period',
              description: 'Incubation has been completed',
              time: '9:41 AM',
            ),
          ],
        ),
      ),
    );
  }
}
